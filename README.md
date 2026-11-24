# Linux Administration Toolkit

A practical Linux administration toolkit built with Bash scripts to monitor system resources, report system information, and assist with basic Linux troubleshooting.

Developed as part of my IT Engineering and Cloud & DevOps learning journey.

## Features

- System information reporting
- CPU load monitoring
- Memory usage monitoring
- Disk usage monitoring
- Configurable disk warning thresholds
- Overall system health reporting
- Error handling and exit codes
- Linux command reference

## Project Structure

```text
linux-admin-toolkit/
├── docs/
│   └── commands.md
├── scripts/
│   ├── system-info.sh
│   ├── disk-check.sh
│   └── system-health.sh
├── .gitignore
└── README.md
```

## Requirements

- Linux operating system
- Bash
- GNU Awk
- Standard Linux utilities

## Installation

Clone the repository:

```bash
git clone git@github.com:JordanANgeloERASMUS/linux-admin-toolkit.git
```

Enter the project directory:

```bash
cd linux-admin-toolkit
```

Make the scripts executable:

```bash
chmod +x scripts/*.sh
```

## Usage

### 1. System Information

Displays information about the operating system, kernel, CPU, memory, disk usage, and system uptime.

```bash
./scripts/system-info.sh
```

### 2. Disk Monitoring

Checks root filesystem usage against a configurable threshold.

Default threshold of 80%:

```bash
./scripts/disk-check.sh
```

Set a custom threshold:

```bash
THRESHOLD=90 ./scripts/disk-check.sh
```

Disk monitoring exit codes:

| Code | Meaning |
|---|---|
| 0 | Disk usage is within the configured threshold |
| 1 | Disk usage has reached or exceeded the threshold |
| 2 | Invalid configuration or disk information error |

### 3. System Health Monitoring

Checks CPU load, memory usage, disk usage, and system uptime.

```bash
./scripts/system-health.sh
```

Monitoring thresholds:

| Usage | Status |
|---|---|
| Below 80% | OK |
| 80% to 94% | WARNING |
| 95% or higher | CRITICAL |

CPU load uses the one-minute Linux load average relative to the number of available CPU cores. This is a normalized load indicator, not a direct CPU utilization measurement.

System health exit codes:

| Code | Meaning |
|---|---|
| 0 | System health is healthy |
| 1 | Warning detected |
| 2 | Critical condition detected |
| 3 | Unable to collect system information |

## Validation and Testing

Run ShellCheck:

```bash
shellcheck scripts/*.sh
```

Check Bash syntax:

```bash
bash -n scripts/system-info.sh scripts/disk-check.sh scripts/system-health.sh
```

## Technologies

- Linux
- Bash scripting
- GNU Awk
- Git
- GitHub

## Learning Objectives

- Linux system administration
- Bash scripting and automation
- System resource monitoring
- Error handling and exit codes
- Command-line troubleshooting
- Git version control
- Technical documentation

## Author

Jordan Erasmus
