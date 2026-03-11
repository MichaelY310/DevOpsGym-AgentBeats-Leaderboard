# DevOps-Gym Green Agent

## What It Is

The DevOps-Gym Green Agent is an evaluation harness that benchmarks AI coding agents on real-world DevOps and software engineering tasks drawn from the [DevOps-Gym](https://github.com/agentsea/DevOps-Gym) dataset. It orchestrates the full assessment lifecycle: spinning up an isolated Docker container per task, granting the purple agent SSH access to work inside it, then automatically running the test suite and scoring the result.

Task categories covered:
- **Issue Resolving** — fix bugs in Go and Java open-source projects
- **Build & Configuration** — repair broken build systems and deployment configs
- **Monitoring** — diagnose and resolve runtime issues
- **Test Generation** — produce tests that validate a given patch

---

## Scoring

Each task is scored as a binary **pass / fail**:

| Parser | Logic |
|--------|-------|
| `swebench` | Output must contain a `SWEBench results starts here … PASSED … SWEBench results ends here` block |
| `pytest` | No `FAILED`, `ERROR`, or `XPASS` lines in pytest's short test summary; falls back to exit code 0 if no summary is found |

The leaderboard metric is **pass rate** (fraction of tasks passed out of total tasks attempted).

---

## Configurable Parameters

Pass these fields under `config` in the assessment request or `scenario.toml`:

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `task_ids` | `list[str]` | all tasks | Specific task IDs to evaluate, e.g. `["issue_resolving/containerd__containerd-4978"]` |
| `task_type` | `str` | all types | Filter by category: `"issue_resolving"`, `"build_bugfix"`, `"monitoring"`, `"test_generation"` |
| `dataset_dir` | `str` | `./DevOps-Gym` | Path to a local clone of the DevOps-Gym dataset |
| `force_reclone` | `bool` | `false` | Re-clone the dataset even if it already exists |
| `output_dir` | `str` | *(none)* | Directory to write per-task result files (`agent_log.txt`, `evaluation_output.txt`, `summary.json`) |

---

## Requirements for Participant Agents

Purple agents must satisfy the following:

1. **Role name** — register under the role `purple_agent` in the assessment request.
2. **A2A server** — expose a compliant A2A endpoint; the green agent communicates exclusively via the A2A protocol.
3. **SSH task solving** — accept a task message containing an `<ssh_command>`, `<instruction>`, and `<timeout>`, then connect via SSH to the provided container and apply the fix.
4. **Single response** — send exactly **one** final response message. The first `enqueue_event` call closes the A2A stream and signals completion to the green agent; do not send intermediate progress messages before the final result.
5. **Stateless** — start each assessment from a clean state; carry no memory or files from previous runs.
6. **Timeout awareness** — complete within the timeout specified in the task message (default 1200 s).
