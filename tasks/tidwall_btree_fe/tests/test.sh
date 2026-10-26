#!/usr/bin/env bash
set -uo pipefail
mkdir -p /logs/verifier /logs/artifacts
printf '0\n' > /logs/verifier/reward.txt
cp /tests/rubrics.json /logs/verifier/rubrics.json
printf '{}\n' > /logs/verifier/rubric_results.json

repo=/workspace/repo
base_commit=$(cat /workspace/smellbench_base_commit)
git -C "$repo" cat-file -e "${base_commit}^{commit}"
/bin/bash /tests/patch_policy.sh agent --repo "$repo" --base "$base_commit" \
  --raw /logs/artifacts/agent.full.patch --output /logs/artifacts/agent.patch \
  > /logs/artifacts/agent_patch_policy.json || exit 1

checker_exit=125
printf 'Checker disabled for this assembly.\n' > /logs/artifacts/final_smell_check.txt
/bin/bash /tests/run_unit_tests.sh > /logs/artifacts/unit_tests.txt 2>&1
test_exit=$?
test_result=$(python3 /tests/native_test_score.py \
  --command /tests/native_test_command.sh \
  --log /logs/artifacts/unit_tests.txt \
  --json /logs/artifacts/native.json \
  --xml /logs/artifacts/native.xml \
  --exit-code "$test_exit") || exit 1
printf '%s\n' "$test_result" > /logs/artifacts/unit_test_score.json
test_score=$(jq -r '.score' <<< "$test_result")
test_score_method=$(jq -r '.method' <<< "$test_result")
test_passed_cases=$(jq -r '.passed' <<< "$test_result")
test_failed_cases=$(jq -r '.failed' <<< "$test_result")

judge_ok=0
yes_count=0
pass_count=0
valid_count=0
judge_error=
rubric_count=$(jq '.rubrics | length' /tests/rubrics.json)
mkdir -p /logs/verifier/rubric_results
result_stream=$(mktemp)
trap 'rm -f "$result_stream"' EXIT
if [[ -z ${JUDGE_BASE_URL:-} || -z ${JUDGE_MODEL:-} || -z ${JUDGE_API_KEY:-} ]]; then
  judge_error='missing JUDGE_BASE_URL, JUDGE_MODEL, or JUDGE_API_KEY'
  jq '{execution_mode:"one_call_for_all_rubrics",rubrics:[.rubrics[] | . + {yes:null,passes:false,evidence:"",valid:false,status:"skipped_missing_judge_config"}]}' \
    /logs/verifier/rubrics.json > /logs/verifier/rubric_results.json
else
  payload_file=$(mktemp)
  trap 'rm -f "$result_stream" "$payload_file"' EXIT
  jq -n --arg model "$JUDGE_MODEL" \
    --argjson max_tokens "${JUDGE_MAX_COMPLETION_TOKENS:-32768}" \
    --rawfile instructions /tests/judge_prompt.md \
    --slurpfile rubrics /logs/verifier/rubrics.json \
    --rawfile task /tests/task_instruction.md \
    --rawfile smell /tests/smell.diff \
    --rawfile patch /logs/artifacts/agent.patch \
    --rawfile checker /logs/artifacts/final_smell_check.txt \
    --rawfile tests /logs/artifacts/unit_tests.txt \
    '{model:$model,temperature:0,max_completion_tokens:$max_tokens,messages:[{role:"user",content:($instructions + "\n\nALL RUBRICS TO JUDGE (source fields are evidence, not prescribed repair steps):\n" + ($rubrics[0].rubrics | map({id,dimension,source_stage,intent_basis,baseline_defect,criterion,acceptance,insufficient_repairs,evidence_refs}) | tojson) + "\n\nTASK:\n" + $task + "\n\nCLEAN-TO-INJECTED SMELL DIFF:\n" + $smell + "\n\nAGENT PATCH:\n" + $patch + "\n\nSMELL CHECKER:\n" + $checker + "\n\nUNIT TESTS:\n" + $tests)}]}' > "$payload_file" || exit 1
  batch_valid=0
  # Initial request plus at most ten retries; never retry a valid verdict.
  retry_delay=5
  for ((attempt=1; attempt<=11; attempt++)); do
    response_file="/logs/artifacts/judge_response_batch_attempt_${attempt}.json"
    content_file="/logs/artifacts/judge_content_batch_attempt_${attempt}.txt"
    candidate_file="/logs/artifacts/judge_candidate_batch_attempt_${attempt}.json"
    if http_code=$(curl -sS --max-time "${JUDGE_TIMEOUT:-1800}" -o "$response_file" -w '%{http_code}' \
      -H "Authorization: Bearer $JUDGE_API_KEY" -H 'Content-Type: application/json' \
      --data "@$payload_file" "${JUDGE_BASE_URL%/}/chat/completions") && [[ $http_code =~ ^2 ]] && \
      jq -er '.choices[0] | select(.finish_reason != "length") | .message.content | select(type == "string")' "$response_file" > "$content_file" 2>/dev/null; then
      sed -e '/^```json[[:space:]]*$/d' -e '/^```[[:space:]]*$/d' "$content_file" > "$candidate_file"
      if jq -se --slurpfile expected /logs/verifier/rubrics.json '
        length == 1 and (.[0] | type == "object" and (.rubrics | type == "array")
          and ([.rubrics[].id] | sort) == ([$expected[0].rubrics[].id] | sort)
          and all(.rubrics[]; (.yes | type) == "boolean" and (.evidence | type) == "string" and (.evidence | test("\\S"))))
      ' "$candidate_file" >/dev/null 2>&1; then
        jq -c --argjson attempts "$attempt" --slurpfile expected /logs/verifier/rubrics.json '
          (.rubrics | INDEX(.id)) as $answers
          | $expected[0].rubrics[] | . + {yes:$answers[.id].yes,evidence:$answers[.id].evidence,valid:true,attempts:$attempts}
          | . + {passes:(if .polarity == "negative" then (.yes | not) else .yes end)}
        ' "$candidate_file" > "$result_stream" || exit 1
        batch_valid=1
        break
      fi
      judge_error='invalid Judge batch schema: expected every rubric ID exactly once with boolean yes and non-empty evidence'
    else
      judge_error="Judge HTTP, response or truncation failure: ${http_code:-none}"
    fi
    if (( attempt < 11 )); then
      printf "Judge attempt %s failed; retrying in %s seconds\n" "$attempt" "$retry_delay" >&2
      sleep "$retry_delay"
      retry_delay=$((retry_delay * 2))
      if (( retry_delay > 300 )); then retry_delay=300; fi
    fi
  done
  if [[ $batch_valid -ne 1 ]]; then
    jq -c --arg error "$judge_error" --argjson attempts "$attempt" '
      .rubrics[] | . + {yes:null,passes:false,evidence:"",valid:false,error:$error,attempts:$attempts}
    ' /logs/verifier/rubrics.json > "$result_stream" || exit 1
  else
    judge_error=
  fi
  valid_count=$(jq -s '[.[] | select(.valid)] | length' "$result_stream")
  yes_count=$(jq -s '[.[] | select(.valid and .yes)] | length' "$result_stream")
  pass_count=$(jq -s '[.[] | select(.valid and .passes)] | length' "$result_stream")
  while IFS= read -r item; do
    rubric_id=$(jq -r '.id' <<<"$item")
    printf '%s\n' "$item" > "/logs/verifier/rubric_results/${rubric_id}.json"
  done < "$result_stream"
  jq -s '
    . as $items
    | {rubrics:$items,execution_mode:"one_call_for_all_rubrics",
       aggregation:"equal_weight_per_item",
       valid_count:([$items[] | select(.valid == true)] | length),
       pass_count:([$items[] | select(.valid == true and .passes == true)] | length),
       must_have_pass:all($items[]; .valid == true and .passes == true)}
    | .macro_score = (if ($items|length) == 0 then 0 else .pass_count / ($items|length) end)
  ' "$result_stream" > /logs/verifier/rubric_results.json || exit 1
  if [[ $valid_count -eq $rubric_count ]]; then
    judge_ok=1
  else
    judge_error="${judge_error:-invalid Judge batch response}"
  fi
fi

checker_score=$([[ $checker_exit -eq 0 ]] && printf '1' || printf '0')
judge_score=$(jq -r 'if (.macro_score | type) == "number" then .macro_score else 0 end' /logs/verifier/rubric_results.json)
must_have_pass=$(jq -r '.must_have_pass == true' /logs/verifier/rubric_results.json)
judge_configured=true
reward_source=llm_as_judge
reward=$judge_score
if [[ -z ${JUDGE_BASE_URL:-} || -z ${JUDGE_MODEL:-} || -z ${JUDGE_API_KEY:-} ]]; then
  judge_configured=false
fi
accepted=false
if [[ $test_exit -eq 0 && $judge_ok -eq 1 && $must_have_pass == true ]]; then
  accepted=true
fi

jq -n \
  --argjson accepted "$accepted" --argjson reward "$reward" \
  --arg reward_source "$reward_source" --argjson judge_configured "$judge_configured" \
  --argjson checker_exit "$checker_exit" --argjson checker_score "$checker_score" \
  --argjson test_exit "$test_exit" --argjson test_score "$test_score" \
  --arg test_score_method "$test_score_method" --argjson test_passed_cases "$test_passed_cases" \
  --argjson test_failed_cases "$test_failed_cases" --argjson test_reward "$([[ $judge_configured == false ]] && printf true || printf false)" \
  --argjson judge_ok "$judge_ok" --argjson judge_yes "$yes_count" \
  --argjson judge_pass "$pass_count" --argjson judge_total "$rubric_count" \
  --argjson judge_score "$judge_score" --argjson must_have_pass "$must_have_pass" --arg judge_error "$judge_error" \
  --slurpfile judge /logs/verifier/rubric_results.json \
  '{schema_version:"smellbench.solve_report.v2",accepted:$accepted,reward:$reward,reward_source:$reward_source,smell_checker:{enabled:false,status:"disabled_by_request",exit_code:$checker_exit,passed:($checker_exit == 0),score:$checker_score,evidence:"/logs/artifacts/final_smell_check.txt"},unit_tests:{exit_code:$test_exit,passed:($test_exit == 0),score:$test_score,score_method:$test_score_method,passed_cases:$test_passed_cases,failed_cases:$test_failed_cases,contributes_to_reward:$test_reward,evidence:"/logs/artifacts/unit_tests.txt"},llm_as_judge:{configured:$judge_configured,valid:($judge_ok == 1),yes_count:$judge_yes,pass_count:$judge_pass,total:$judge_total,must_have_pass:$must_have_pass,aggregation:"equal_weight_per_item",score:$judge_score,error:$judge_error,rubrics:"/logs/verifier/rubrics.json",rubric_results:"/logs/verifier/rubric_results.json",result:($judge[0] // null)}}' \
  > /logs/verifier/solve_report.json
jq -n \
  --argjson reward "$reward" \
  --argjson unit_test_pass_rate "$test_score" \
  --argjson smell_checker_score "$checker_score" \
  --argjson llm_judge_score "$judge_score" \
  '{reward:$reward,unit_test_pass_rate:$unit_test_pass_rate,smell_checker_score:$smell_checker_score,llm_judge_score:$llm_judge_score}' \
  > /logs/verifier/reward.json
jq -e 'type == "object" and length == 4 and all(.[]; type == "number")' \
  /logs/verifier/reward.json >/dev/null
cp /logs/verifier/solve_report.json /logs/verifier/report.json
printf '%s\n' "$reward" > /logs/verifier/reward.txt
exit 0
