#!/usr/bin/env python3
"""Read native test outcomes without changing the repository's test command."""

import argparse
import json
import re
import xml.etree.ElementTree as ET
from pathlib import Path


def result(passed, failed, method):
    if passed < 0 or failed < 0 or passed + failed == 0:
        return None
    return {"passed": passed, "failed": failed, "score": passed / (passed + failed), "method": method}


def js_json(path):
    if not path.is_file():
        return None
    try:
        data = json.loads(path.read_text(errors="replace"))
    except (OSError, json.JSONDecodeError):
        return None
    if not isinstance(data, dict):
        return None
    passed, failed = data.get("numPassedTests"), data.get("numFailedTests")
    if type(passed) is int and type(failed) is int:
        return result(passed, failed, "js_test_json")
    return None


def junit_xml(path):
    if not path.is_file():
        return None
    try:
        root = ET.parse(path).getroot()
    except (OSError, ET.ParseError):
        return None
    cases = list(root.iter("testcase"))
    if cases:
        failed = sum(any(child.tag in {"failure", "error"} for child in case) for case in cases)
        skipped = sum(any(child.tag == "skipped" for child in case) for case in cases)
        return result(len(cases) - failed - skipped, failed, "junit_xml")
    return None


def pytest_summary(log):
    matches = re.findall(r"(?m)^=+\s*(.*?)\s+in\s+\d+(?:\.\d+)?s\s*=+\s*$", log)
    if not matches:
        return None
    passed = failed = 0
    for summary in matches:
        for count, outcome in re.findall(r"(\d+) (passed|failed|errors?|xpassed|xfailed|skipped)", summary):
            if outcome in {"passed", "xpassed"}:
                passed += int(count)
            elif outcome in {"failed", "error", "errors"}:
                failed += int(count)
    return result(passed, failed, "pytest_summary")


def go_json(log):
    terminals = {}
    package_failures = set()
    for line in log.splitlines():
        try:
            item = json.loads(line)
        except json.JSONDecodeError:
            continue
        if not isinstance(item, dict):
            continue
        action = item.get("Action")
        if action not in {"pass", "fail"}:
            continue
        package = item.get("Package")
        test = item.get("Test")
        if isinstance(test, str) and test:
            terminals[(package, test)] = action
        elif action == "fail" and isinstance(package, str):
            package_failures.add(package)
    passed = sum(action == "pass" for action in terminals.values())
    failed = sum(action == "fail" for action in terminals.values())
    # A package may fail before it emits any test result (build/setup failure).
    failed += sum(
        not any(pkg == package and action == "fail" for (pkg, _), action in terminals.items())
        for package in package_failures
    )
    return result(passed, failed, "go_test_json")


def cargo_log(log):
    passed = len(re.findall(r"(?m)^test .+ \.\.\. ok\s*$", log))
    failed = len(re.findall(r"(?m)^test .+ \.\.\. FAILED\s*$", log))
    if passed + failed:
        return result(passed, failed, "cargo_test_output")
    totals = re.findall(r"test result: (?:ok|FAILED)\. (\d+) passed; (\d+) failed;", log)
    if totals:
        return result(sum(int(p) for p, _ in totals), sum(int(f) for _, f in totals), "cargo_test_summary")
    return None


def ctest_log(log):
    statuses = re.findall(r"(?m)^\s*\d+/\d+\s+Test\s+#\d+:.*?\s+\*{0,3}(Passed|Failed|Timeout|Not Run)\s+", log)
    if statuses:
        return result(statuses.count("Passed"), sum(x != "Passed" for x in statuses), "ctest_output")
    matches = re.findall(r"(?m)\d+% tests passed, (\d+) tests failed out of (\d+)", log)
    if matches:
        failed, total = (int(value) for value in matches[-1])
        return result(total - failed, failed, "ctest_summary")
    return None


def meson_log(log):
    matches = re.findall(r"(?m)^\s*\d+/\d+\s+.+?\s+(OK|FAIL|TIMEOUT|ERROR)(?:\s|$)", log)
    if matches:
        return result(matches.count("OK"), sum(x != "OK" for x in matches), "meson_output")
    summaries = re.findall(r"(?ms)^Ok:\s*(\d+).*?^Fail:\s*(\d+)", log)
    if summaries:
        passed, failed = map(int, summaries[-1])
        return result(passed, failed, "meson_summary")
    return None


def php_log(log):
    matches = re.findall(r"(?m)^Tests passed\s*:\s*(\d+)", log)
    totals = re.findall(r"(?m)^Tests failed\s*:\s*(\d+)", log)
    if matches and totals:
        return result(int(matches[-1]), int(totals[-1]), "php_test_summary")
    return None


def automake_log(log):
    matches = re.findall(r"(?ms)^# TOTAL:\s*(\d+).*?^# PASS:\s*(\d+).*?^# (?:FAIL|ERROR):\s*(\d+)", log)
    if matches:
        _, passed, failed = matches[-1]
        return result(int(passed), int(failed), "automake_summary")
    return None


def tap_log(log):
    passed = len(re.findall(r"(?m)^ok\s+\d+\b", log))
    failed = len(re.findall(r"(?m)^not ok\s+\d+\b", log))
    return result(passed, failed, "tap_output")


def unittest_log(log):
    totals = re.findall(r"(?m)^Ran (\d+) tests? in ", log)
    if not totals:
        return None
    total = int(totals[-1])
    failures = re.findall(r"(?m)^FAILED \((.*?)\)", log)
    if failures:
        failed = sum(int(number) for number in re.findall(r"(?:failures|errors)=(\d+)", failures[-1]))
        return result(total - failed, failed, "unittest_summary")
    if re.search(r"(?m)^OK(?: \(skipped=\d+\))?$", log):
        return result(total, 0, "unittest_summary")
    return None


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--command", type=Path, required=True)
    parser.add_argument("--log", type=Path, required=True)
    parser.add_argument("--json", type=Path, required=True)
    parser.add_argument("--xml", type=Path, required=True)
    parser.add_argument("--exit-code", type=int, required=True)
    args = parser.parse_args()
    command = args.command.read_text(errors="replace")
    log = args.log.read_text(errors="replace")
    if "pytest" in command:
        outcome = pytest_summary(log)
    elif re.search(r"\bgo test\b", command):
        outcome = go_json(log)
    elif "cargo test" in command:
        outcome = cargo_log(log)
    elif "ctest" in command:
        outcome = junit_xml(args.xml) or ctest_log(log)
    elif "meson test" in command:
        outcome = meson_log(log)
    elif "make test" in command or "make check" in command:
        outcome = php_log(log) or automake_log(log) or ctest_log(log) or tap_log(log)
    else:
        outcome = js_json(args.json) or automake_log(log) or tap_log(log) or unittest_log(log)
    # A JSON reporter can be used by JS commands that also invoke lint first.
    if outcome is None and args.json.is_file():
        outcome = js_json(args.json)
    if outcome is None:
        outcome = {"passed": None, "failed": None, "score": float(args.exit_code == 0), "method": "exit_status_no_case_counts"}
    print(json.dumps(outcome, separators=(",", ":")))


if __name__ == "__main__":
    main()
