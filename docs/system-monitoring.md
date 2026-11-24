# System Monitoring Documentation

## Overview

The Linux Administration Toolkit includes scripts that collect system information and monitor important system resources.

The monitoring tools check CPU load, memory usage, and disk usage to help identify potential system performance issues.

## CPU Load Monitoring

The system health script reads the one-minute load average from `/proc/loadavg`.

It compares this value against the number of available CPU cores to calculate a normalized load indicator.

This provides an indication of system load relative to available CPU capacity.

**Note:** Linux load average is not the same as CPU utilization. It can include processes waiting for CPU time or uninterruptible I/O.

## Memory Monitoring

Memory information is collected from `/proc/meminfo`.

The script uses:

- MemTotal: Total physical memory.
- MemAvailable: Estimated memory available for new applications.

Memory usage is calculated using:

`(MemTotal - MemAvailable) / MemTotal * 100`

## Disk Monitoring

Disk usage is collected using the `df` command.

The toolkit monitors the root filesystem (`/`) and compares its usage against a configurable threshold.

The disk monitoring script uses an 80% warning threshold by default.

A custom threshold can be supplied through the `THRESHOLD` environment variable.

Example:

`THRESHOLD=90 ./scripts/disk-check.sh`

## Health Monitoring Thresholds

| Percentage | Status |
|---|---|
| Below 80% | OK |
| 80% to 94% | WARNING |
| 95% or higher | CRITICAL |

These thresholds are configurable in the system health script.

## Exit Codes

### Disk Monitoring

| Code | Meaning |
|---|---|
| 0 | Disk usage is below the threshold |
| 1 | Disk usage reached or exceeded the threshold |
| 2 | Invalid configuration or disk information error |

### System Health Monitoring

| Code | Meaning |
|---|---|
| 0 | System health is healthy |
| 1 | Warning detected |
| 2 | Critical condition detected |
| 3 | Unable to collect system information |

## Testing

The scripts can be checked using ShellCheck:

`shellcheck scripts/*.sh`

Bash syntax can be validated using:

`bash -n scripts/system-info.sh scripts/disk-check.sh scripts/system-health.sh`

## Author

Jordan Erasmus
