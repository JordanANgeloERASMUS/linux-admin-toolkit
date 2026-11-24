
# Linux Health Check Automation

## Overview

The Linux Health Check Automation tool extends the Linux Administration Toolkit by automating the execution of the system health monitoring script.

It runs the existing `system-health.sh` script, captures its output, records timestamps, preserves exit codes, and stores monitoring results in a log file.

The automation is designed for manual execution by default. No scheduled tasks are installed or activated automatically.

## Features

- Executes the system health monitoring script.
- Automatically creates the log directory if it does not exist.
- Records the start and completion timestamps.
- Saves monitoring output and error messages.
- Preserves the original monitoring script exit code.
- Appends new results without overwriting previous logs.
- Rotates logs when the current log reaches 1 MB.
- Archives previous logs instead of deleting them.

## Project Files

```text
linux-admin-toolkit/
├── docs/
│   ├── commands.md
│   ├── system-monitoring.md
│   └── automation.md
├── scripts/
│   ├── system-info.sh
│   ├── disk-check.sh
│   ├── system-health.sh
│   └── run-health-check.sh
├── .gitignore
└── README.md
```

## Requirements

- Linux operating system
- Bash
- GNU Coreutils
- Existing system-health.sh script

## Running the Automation

Navigate to the project directory:

```bash
cd ~/Projects/linux-admin-toolkit
```

Make the automation script executable:

```bash
chmod +x scripts/run-health-check.sh
```

Execute the automation manually:

```bash
./scripts/run-health-check.sh
```

The script runs the existing system health monitoring tool and saves its results.

## Logging

Monitoring logs are stored outside the project directory:

```text
~/.local/state/linux-admin-toolkit/system-health.log
```

This keeps personal system monitoring data separate from the GitHub repository.

The script uses output redirection:

- `>>` appends output to an existing file.
- `2>&1` redirects error output into the same log.

Previous monitoring results are preserved.

## Log Rotation

To prevent the log file from growing indefinitely, the automation checks its size before each run.

The configured maximum size is:

```bash
MAX_LOG_SIZE=1048576
```

This represents 1 MiB (1,048,576 bytes).

When the existing log reaches or exceeds this size, it is renamed using a timestamp.

Example archived filename:

```text
system-health-20261124-173910.log
```

A new log file is then created when the monitoring results are written.

Archived logs are preserved and are not automatically deleted.

## Exit Codes

The automation returns the exit code from the system health monitoring script.

| Exit Code | Meaning |
|---|---|
| 0 | System health check completed with healthy status |
| 1 | Warning detected |
| 2 | Critical condition detected |
| 3 | Unable to collect system health information |

Exit codes 1, 2 and 3 represent monitoring outcomes or errors from the underlying health-check script. They do not necessarily mean the automation wrapper itself failed.

The wrapper also uses exit code 2 for certain setup and log rotation errors.

## Testing

Check Bash syntax:

```bash
bash -n scripts/run-health-check.sh
```

Run ShellCheck:

```bash
shellcheck scripts/run-health-check.sh
```

Execute the automation:

```bash
./scripts/run-health-check.sh
```

Inspect the log:

```bash
cat "$HOME/.local/state/linux-admin-toolkit/system-health.log"
```

Display the latest 35 lines:

```bash
tail -n 35 "$HOME/.local/state/linux-admin-toolkit/system-health.log"
```

Count completed monitoring runs:

```bash
grep -c "Health check completed:" \
"$HOME/.local/state/linux-admin-toolkit/system-health.log"
```

Inspect the log file size:

```bash
du -h "$HOME/.local/state/linux-admin-toolkit/system-health.log"
```

## Log Rotation Testing

Log rotation can be tested safely using a temporary directory rather than modifying the real monitoring log.

A temporary test environment can be created using:

```bash
TEST_HOME=$(mktemp -d)

mkdir -p "$TEST_HOME/.local/state/linux-admin-toolkit"
```

Create a test log of 1 MiB:

```bash
truncate -s 1048576 \
"$TEST_HOME/.local/state/linux-admin-toolkit/system-health.log"
```

Run the automation using the temporary home directory:

```bash
HOME="$TEST_HOME" ./scripts/run-health-check.sh
```

Inspect the archived and newly created logs:

```bash
find "$TEST_HOME/.local/state/linux-admin-toolkit" \
-maxdepth 1 -type f -printf '%f — %s bytes\n'
```

Remove the temporary test environment:

```bash
rm -rf "$TEST_HOME"
```

This test does not modify the real monitoring log stored in the user's home directory.

## Optional Cron Integration

The automation can optionally be configured with Cron on a Linux system.

Cron allows commands to execute according to a schedule.

Example of a schedule that would execute the monitoring script every hour:

```cron
0 * * * * /home/username/linux-admin-toolkit/scripts/run-health-check.sh
```

This is an example only.

No Cron schedule is installed or activated by this project.

Users should understand the schedule, log location and resource implications before enabling automated execution.

## Learning Objectives

This project demonstrates practical experience with:

- Linux system administration.
- Bash scripting.
- Script execution and permissions.
- Variables and command substitution.
- Conditional statements.
- File and directory management.
- Output redirection.
- Logging and timestamps.
- Exit-code handling.
- Log rotation.
- Temporary test environments.
- ShellCheck and Bash syntax validation.
- Git version control and documentation.

## Author

Jordan Erasmus

Linux Administration Toolkit
