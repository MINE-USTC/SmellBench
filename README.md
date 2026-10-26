# SmellBench

**Towards Fine-Grained Evaluation of Code Agents on Refactoring Tasks**

SmellBench evaluates behavior-preserving, repository-level refactoring. Each task starts from a real open-source repository with injected code smells and asks an agent to reorganize the affected code without changing its intended behavior. Repository-native tests check functional preservation; case-specific rubrics assess structural repair beyond test passing.

SmellBench comprises **95 Harbor-style refactoring tasks from 47 repositories**, covering **5 languages, 7 smell categories, and 1,570 rubric criteria**. It provides a controlled testbed for studying smell-specific repair capabilities, responsibility allocation, and cross-file coordination.

## Benchmark construction

The benchmark uses seed repository selection followed by multi-stage smell injection:

1. **Smell propagation** expands a structural defect across related functions, classes, and files.
2. **Smell entanglement** introduces intertwined responsibilities and dependencies that require coherent reconstruction rather than isolated local edits.
3. **Verification and review** combine repository-native tests, injection-artifact cleanup, and case review.

The reference repair is derived from the original clean code. Agents may use equivalent designs: matching the reference patch text or file set is not an evaluation requirement.

## Dataset statistics

| Smell category | Tasks |
| --- | ---: |
| Data Clumps | 14 |
| Dead Code Elimination | 18 |
| Deeply Inlined Method | 17 |
| Feature Envy | 13 |
| God Classes | 6 |
| Interface Segregation | 16 |
| Shotgun Surgery | 11 |
| **Total** | **95** |

| Primary language | Tasks |
| --- | ---: |
| C | 18 |
| Go | 18 |
| Python | 19 |
| Rust | 22 |
| TypeScript | 18 |

Counts above are **tasks**, not repositories. Each task has 16.53 rubric items on average.

## Task layout

```text
tasks/<task_id>/
├── instruction.md                 # Agent-facing refactoring request
├── task.toml                      # Pinned repository, resources, timeouts and metadata
├── environment/
│   ├── Dockerfile                 # Build repository environment and inject the smell
│   └── smell.diff                 # Clean-to-injected patch
├── solution/
│   ├── gt.patch                   # Reference repair from injected to clean code
│   └── solve.sh                   # Reference execution entry point
└── tests/
    ├── test.sh                    # Patch extraction, native tests and rubric Judge
    ├── rubrics.json               # Case-specific structural criteria
    ├── judge_prompt.md            # Judge instructions
    ├── patch_policy.sh            # Agent patch processing policy
    ├── native_test_command.sh     # Repository-specific test command
    ├── run_unit_tests.sh          # Test execution wrapper
    ├── native_test_score.py       # Native test outcome parsing
    ├── task_instruction.md        # Verifier-side request copy
    ├── smell.diff                 # Verifier-side injected patch
    └── control_smell.diff         # Control patch used by the verification workflow
```

Each Dockerfile builds the pinned repository revision and applies `smell.diff` to create the agent's starting state. The reference patch repairs this injected state back to the original clean code. Keep `solution/` and verifier-only material outside the agent-visible repository.

## Running and configuring evaluation

Use a compatible [Harbor](https://github.com/laude-institute/harbor) installation with Docker/container execution available. Select `tasks/` as the local dataset, or a single `tasks/<task_id>/` directory for a smoke test. Configure the agent and environment options supported by your installed Harbor version.

The verifier requires Bash, Python, Git, jq, curl, and each repository's native toolchain, supplied by the task environment. Image builds need access to upstream repositories and dependency registries. Configure these variables **in the verifier environment**, without committing credentials:

| Variable | Purpose |
| --- | --- |
| `JUDGE_BASE_URL` | OpenAI-compatible API base URL; the verifier appends `/chat/completions` |
| `JUDGE_MODEL` | Judge model identifier |
| `JUDGE_API_KEY` | Runtime authentication secret |
| `JUDGE_MAX_COMPLETION_TOKENS` | Optional Judge output limit; inspect `tests/test.sh` for its default |
| `JUDGE_TIMEOUT` | Optional per-request timeout |

Missing Judge configuration is **not** a native-test-only evaluation mode: inspect the verifier's recorded configuration/error status. Judge requests include task text, rubric criteria, patches and test logs; only use an endpoint authorized to receive that material.

Task environment variables prefixed `CC_FORBIDDEN_REPO_` identify protected source repositories for a compatible harness guard. Enable the corresponding harness integration to enforce source-access restrictions; environment variables alone do not block network access.

## Evaluation metrics

The structural rubrics cover four dimensions:

| Dimension | Abbreviation | Focus |
| --- | --- | --- |
| Smell elimination | SE | Remove the targeted structural defect |
| Responsibility allocation | RA | Give related operations and data coherent ownership |
| Cross-file coordination | CF | Update collaborating components and dependencies consistently |
| Extensibility | EX | Localize future changes through appropriate abstractions |

**TPR** is the mean task-level repository-native test pass rate. It is not limited to Python/pytest tests.

**Solved** is binary per evaluated task: all valid rubric criteria must pass. Report the mean over evaluated tasks, excluding missing evaluations rather than treating them as failures. A dimension likewise receives 1 only when all its valid criteria pass; tasks without valid criteria in that dimension are excluded from its denominator.

The verifier also records a scalar reward and `macro_score` for rubric-item satisfaction. These differ from the binary **Solved** metric, which is derived from the valid rubric verdicts. Native test results are reported separately and do not contribute to the structural reward.

## Experimental results

Percentages below reproduce the recorded evaluation summary. Each configuration was run once per task. OpenHands–Opus 5 currently has 94 available evaluations; Claude Code–Kimi-K3 has 94 completed evaluations. Other configurations have 95. Dimension denominators can be smaller because only tasks with valid criteria in that dimension are included.

| Harness | Model | N | TPR | Solved | SE | RA | CF | EX |
| --- | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| OpenHands | GPT-6 Astra | 95 | 99.99 | 68.42 | 82.67 | 75.86 | 79.75 | 90.32 |
| OpenHands | Opus 5 | 94 | 98.29 | 68.09 | 82.43 | 80.00 | 85.53 | 85.00 |
| OpenHands | Kimi-K3 | 95 | 97.89 | 48.42 | 64.86 | 62.79 | 67.95 | 75.41 |
| OpenHands | DeepSeek-4.1 Flash | 95 | 97.34 | 45.26 | 61.84 | 55.68 | 70.00 | 80.95 |
| OpenHands | GLM-5.3 | 95 | 100.00 | 53.68 | 72.97 | 66.28 | 74.36 | 75.41 |
| OpenHands | GLM-5.2 | 95 | 96.75 | 31.58 | 47.30 | 43.53 | 50.65 | 58.33 |
| Claude Code | GPT-6 Astra | 95 | 99.99 | 69.47 | 87.84 | 84.88 | 88.46 | 86.89 |
| Claude Code | Opus 5 | 95 | 99.91 | 64.21 | 74.67 | 75.29 | 79.22 | 88.33 |
| Claude Code | Kimi-K3 | 94 | 99.98 | 47.87 | 61.64 | 59.30 | 76.92 | 73.77 |
| Claude Code | DeepSeek-4.1 Flash | 95 | 100.00 | 45.26 | 59.46 | 56.98 | 66.67 | 72.13 |
| Claude Code | GLM-5.3 | 95 | 99.99 | 51.58 | 72.97 | 59.30 | 75.64 | 78.69 |
| Claude Code | GLM-5.2 | 95 | 99.91 | 33.68 | 44.59 | 45.88 | 57.14 | 60.00 |

### Findings

- **Passing tests does not establish structural repair.** Mean TPR ranges from 96.75% to 100%, while Solved ranges from 31.58% to 69.47%.
- **The strongest recorded configuration still leaves substantial headroom.** GPT-6 Astra with Claude Code solves 69.47%; success requires satisfying every valid structural criterion, not just obtaining a high average rubric score.
- **Model differences remain visible despite near-ceiling tests.** GLM-5.3 exceeds GLM-5.2 by 22.10 percentage points under OpenHands and 17.90 points under Claude Code (using displayed rounded values).
- **Repair scope matters, but file coverage is not sufficient.** In the Claude Code analysis, GPT-6 Astra solves 81.25% of tasks in the smallest reference-patch bucket versus 46.67% in the largest. GLM-5.3 has higher mean reference-file recall than Opus 5 (87.18% vs. 86.50%) but lower Solved (51.58% vs. 64.21%). These are descriptive associations, not causal findings or reference-match requirements.

## Reproducibility

- Record the task and rubric versions, model versions, harness configuration, and Judge configuration when comparing experiments.
- Multiple tasks share repositories; a single run per configuration does not establish statistical significance or independent samples.
- Native tests cover existing behavior but are not an exhaustive behavioral equivalence proof. Reference file coverage is not a correctness metric.

## Attribution

Repository URLs and pinned commits are recorded in each task's metadata. Upstream repositories and code fragments retain their original license and attribution requirements.

## Reference

**SmellBench: Towards Fine-Grained Evaluation of Code Agents on Refactoring Tasks.**

Publication metadata and a finalized citation will be added when available.
