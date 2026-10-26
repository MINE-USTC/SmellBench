#!/usr/bin/env bash
# Git owns patch serialization and object hashes. jq is already a verifier dependency.
set -euo pipefail
mode=${1:?expected pair or agent}; shift
repo= base= smell= gt= raw= output= check=false
while (($#)); do
  case "$1" in
    --repo) repo=$2; shift 2;; --base) base=$2; shift 2;;
    --smell) smell=$2; shift 2;; --gt) gt=$2; shift 2;;
    --raw) raw=$2; shift 2;; --output) output=$2; shift 2;;
    --check) check=true; shift;; *) echo "Unknown option: $1" >&2; exit 2;;
  esac
done
[[ -n $repo && -n $base ]] || exit 2
command -v jq >/dev/null
scratch=$(mktemp -d "${TMPDIR:-/tmp}/smellbench-patch.XXXXXXXX")
trap 'rm -rf -- "$scratch"' EXIT
export GIT_INDEX_FILE="$scratch/index"
g() { git --literal-pathspecs -C "$repo" "$@"; }
base=$(g rev-parse --verify "${base}^{tree}")

excluded_path() {
  local p="/$1" n=${1##*/}
  # All test changes, not only added files. Directory-scoped resources go too.
  case "$p" in
    */test/*|*/tests/*|*/__tests__/*|*/spec/*|*/specs/*|*/__snapshots__/*|*/__mocks__/*|*/testdata/*|*/test-fixtures/*|*/test_resources/*|*/test-resources/*|*/src/androidTest/*|*/src/integrationTest/*|*/src/testFixtures/*|*/cypress/*|*/playwright-report/*|*/test-results/*|*/htmlcov/*|*/.pytest_cache/*|*/.nyc_output/*|*/gradle/dependency-locks/*|*/requirements/test.txt|*/requirements/tests.txt|*/requirements/testing.txt) return 0;;
  esac
  case "$n" in
    *_test.go|test_*.py|*_test.py|conftest.py|*.test.*|*.spec.*|*Test.java|*Tests.java|Test*.java|*Test.kt|*Tests.kt|*_test.rs|test_*.rs|test_*.c|*_test.c|test_*.h|*_test.h|*_spec.rb) return 0;;
    yarn.lock|package-lock.json|npm-shrinkwrap.json|pnpm-lock.yaml|Cargo.lock|poetry.lock|uv.lock|Pipfile.lock|composer.lock|Gemfile.lock|go.sum|bun.lock|bun.lockb|packages.lock.json|gradle.lockfile) return 0;;
    pytest.ini|tox.ini|.coveragerc|.nycrc|.nycrc.json|coverage.xml|lcov.info|junit.xml|.coverage|jest.config.*|vitest.config.*|playwright.config.*|karma.conf.*|karma.config.*|cypress.config.*|.mocharc.*|.rspec|testng.xml|junit-platform.properties|CTestTestfile.cmake|CTestConfig.cmake|CTestCustom.cmake|tsconfig.test*.json|tsconfig.spec*.json|requirements-test*.txt|requirements_test*.txt|test-requirements.txt|requirements.test*.txt) return 0;;
  esac
  return 1
}

mixed_manifest() {
  # No regex editing of TOML/XML/build programs: ambiguous changes must be reviewed.
  # fst's src/raw/build.rs is a production module, not a Cargo build script.
  [[ $1 == src/raw/build.rs ]] && return 1
  case "${1##*/}" in
    Cargo.toml|pyproject.toml|setup.py|setup.cfg|Pipfile|requirements*.txt|pom.xml|build.gradle|build.gradle.kts|settings.gradle|settings.gradle.kts|gradle.properties|go.mod|CMakeLists.txt|Makefile|*.cmake|build.rs|.babelrc|.babelrc.json|babel.config.*|tsconfig.json) return 0;;
  esac
  return 1
}

log_path() { jq -cn --arg path "$1" --arg reason "$2" '{path:$path,reason:$reason}' >> "$scratch/excluded.ndjson"; }

toml_test_only_change() {
  local p=$1 target=$2 side ref
  case "${p##*/}" in Cargo.toml|pyproject.toml) ;; *) return 1;; esac
  for side in old new; do
    if [[ $side == old ]]; then ref=$base; else ref=$target; fi
    if g cat-file -e "$ref:$p" 2>/dev/null; then
      g show "$ref:$p" > "$scratch/toml.$side"
    else
      : > "$scratch/toml.$side"
    fi
    # Deliberately bounded: no arbitrary TOML parser or multiline-string guessing.
    if grep -Eq "\"\"\"|'''" "$scratch/toml.$side"; then return 1; fi
    awk '
      /^[[:space:]]*\[/ {
        s=$0; sub(/^[[:space:]]*/, "", s); sub(/[[:space:]]*(#.*)?$/, "", s);
        skip=(s ~ /^\[tool\.(pytest|coverage)(\.[^]]+)?\]$/ ||
              s ~ /^\[(target\..+\.)?dev-dependencies(\.[^]]+)?\]$/ ||
              s == "[[test]]");
      }
      !skip && $0 !~ /^[[:space:]]*$/ {print}
    ' "$scratch/toml.$side" > "$scratch/toml.$side.production" || return 1
  done
  cmp -s "$scratch/toml.old.production" "$scratch/toml.new.production"
}

filter_package() {
  local p=$1 target=$2
  if ! g cat-file -e "$target:$p" 2>/dev/null; then
    echo "Mixed manifest deletion requires review: $p" >&2; return 1
  fi
  if g cat-file -e "$base:$p" 2>/dev/null; then g show "$base:$p" > "$scratch/package.old"; else printf '{}\n' > "$scratch/package.old"; fi
  g show "$target:$p" > "$scratch/package.new"
  jq -n --slurpfile old "$scratch/package.old" --slurpfile new "$scratch/package.new" '
    def testdep: test("^(@jest/|@testing-library/|@vitest/|jest-)") or
      IN("jest","babel-jest","ts-jest","react-test-renderer","@types/jest","@types/react-test-renderer","vitest","mocha","chai","nyc","c8","@playwright/test","cypress");
    def testscript: test("^(pretest|posttest|test|coverage)(:|$)");
    $old[0] as $o | $new[0] as $n |
    if ($o|type)!="object" or ($n|type)!="object" then error("invalid package manifest") else $n end |
    reduce ["dependencies","devDependencies","optionalDependencies","scripts"][] as $s (.;
      reduce (((($o[$s] // {}) + ($n[$s] // {})) | keys)[]) as $k (.;
        if (if $s == "scripts" then ($k|testscript) else ($k|testdep) end) then
          if (($o[$s] // {})|has($k)) then .[$s][$k]=$o[$s][$k] else del(.[$s][$k]) end
        else . end) |
      if .[$s] == {} and ($o|has($s)|not) then del(.[$s]) else . end) |
    reduce ["jest","vitest","nyc"][] as $s (.; if ($o|has($s)) then .[$s]=$o[$s] else del(.[$s]) end)
  ' > "$scratch/package.filtered"
  # Any residual semantic manifest change might hide a transitive test dependency.
  # Fail closed, rather than silently dropping a legitimate production dependency.
  if ! jq -e -n --slurpfile a "$scratch/package.old" --slurpfile b "$scratch/package.filtered" '$a[0] == $b[0]' >/dev/null; then
    echo "Unclassified package.json changes require review: $p (keep production manifests unchanged for a refactoring task)" >&2
    return 1
  fi
  log_path "$p" 'test dependency/configuration or formatting; baseline restored'
}

normalize() {
  local target=$1 p
  local excludes=(.)
  g diff --name-only --no-renames -z "$base" "$target" -- > "$scratch/paths"
  while IFS= read -r -d '' p; do
    if excluded_path "$p"; then
      log_path "$p" 'test path, test-only configuration, or lockfile'
      excludes+=(":(top,literal,exclude)$p")
    elif [[ ${p##*/} == package.json ]]; then
      filter_package "$p" "$target" || return 1
      excludes+=(":(top,literal,exclude)$p")
    elif mixed_manifest "$p"; then
      if toml_test_only_change "$p" "$target"; then
        log_path "$p" 'only recognized TOML test sections changed; baseline restored'
        excludes+=(":(top,literal,exclude)$p")
      else
        echo "Mixed build/dependency configuration requires review: $p. Do not add test dependencies; do not discard production changes." >&2
        return 1
      fi
    fi
  done < "$scratch/paths"
  # Explicitly enable pathspec magic here, unlike literal object/file lookups above.
  git --no-literal-pathspecs -C "$repo" diff --binary --full-index --no-ext-diff --no-textconv --no-renames "$base" "$target" -- "${excludes[@]}" > "$scratch/filtered.diff"
  g read-tree "$base"
  if [[ -s $scratch/filtered.diff ]]; then g apply --cached --whitespace=nowarn "$scratch/filtered.diff"; fi
  g write-tree
}

diff_trees() { g diff --binary --full-index --no-ext-diff --no-textconv --no-renames "$1" "$2" --; }
: > "$scratch/excluded.ndjson"
g read-tree "$base"
case "$mode" in
  pair)
    [[ -n $smell && -n $gt ]] || exit 2
    g apply --cached --whitespace=nowarn < "$smell"
    injected=$(g write-tree)
    g apply --cached --whitespace=nowarn < "$gt"
    repaired=$(g write-tree)
    filtered_injected=$(set -e; normalize "$injected")
    filtered_repaired=$(set -e; normalize "$repaired")
    diff_trees "$base" "$filtered_injected" > "$scratch/smell.diff"
    diff_trees "$filtered_injected" "$filtered_repaired" > "$scratch/gt.patch"
    [[ -s $scratch/smell.diff && -s $scratch/gt.patch ]] || { echo 'Empty injection or repair after filtering' >&2; exit 1; }
    if [[ $check == true ]]; then
      cmp -s "$smell" "$scratch/smell.diff" && cmp -s "$gt" "$scratch/gt.patch" || { echo 'Normalize and revalidate the patch pair before packaging' >&2; exit 1; }
    else
      [[ -e $smell.unfiltered ]] || cp "$smell" "$smell.unfiltered"
      [[ -e $gt.unfiltered ]] || cp "$gt" "$gt.unfiltered"
      cp "$scratch/smell.diff" "$smell"
      cp "$scratch/gt.patch" "$gt"
    fi
    ;;
  agent)
    [[ -n $raw && -n $output && $raw != "$output" ]] || exit 2
    g add -A -- .
    current=$(g write-tree)
    diff_trees "$base" "$current" > "$raw"
    # Truncate stale judge evidence before attempting normalization.
    : > "$output"
    normalized=$(set -e; normalize "$current")
    diff_trees "$base" "$normalized" > "$output"
    ;;
  *) echo 'Expected pair or agent' >&2; exit 2;;
esac
jq -s '{excluded:unique_by(.path),policy:"git-test-exclusion-v2"}' "$scratch/excluded.ndjson"
