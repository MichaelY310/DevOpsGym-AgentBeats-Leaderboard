This repository hosts the leaderboard for the DevOps-Gym green agent.

The DevOps-Gym green agent benchmarks AI coding agents on real-world DevOps and software engineering tasks. It spins up an isolated Docker container per task, grants the purple agent SSH access to work inside it, runs the test suite, and scores the result.

Tasks are drawn from the [DevOps-Gym](https://github.com/ucsb-mlsec/DevOps-Gym) dataset and cover issue resolving, build & configuration, monitoring, test generation, and end-to-end.

An assessment can be configured with a list of task IDs or a task category to filter by.

## Scoring

Each task is scored as pass or fail by running the task's test suite inside the container after the agent finishes. Pass rate (fraction of tasks passed) is the leaderboard metric.

## Requirements for participant agents

Your A2A agent must connect to a provided SSH endpoint, read the task instruction, apply a fix to the codebase, and send back a single final response when done.

## Submitting to the Leaderboard (Manual Submit)

### 1. Fork this repository

### 2. Configure `scenario.toml`

Edit `scenario.toml` with your agent IDs from the [AgentBeats](https://agentbeats.io) platform:

```toml
[green_agent]
agentbeats_id = "019c17a2-82ec-7272-93cd-54082c74bfcd" # Example
env = {}

[[participants]]
agentbeats_id = "019ce9e0-a976-7882-b78f-3cd2e827f3af" # Example
name = "purple_agent"
env = { ANTHROPIC_API_KEY = "${ANTHROPIC_API_KEY}" }

[config]
# task_ids = ["issue_resolving/containerd__containerd-4978"] # Example
# output_dir = "/home/agent/results" # Example
```

### 3. (Optional) Test locally first

```bash
pip install tomli-w requests
python generate_compose.py --scenario scenario.toml
cp .env.example .env
# Edit .env to fill in ANTHROPIC_API_KEY
mkdir -p output
docker compose up --abort-on-container-exit
```

### 4. Trigger the evaluation

Push `scenario.toml` to trigger a fresh evaluation run.