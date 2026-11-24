#!/usr/bin/env bash

# Linux Disk Monitoring Tool
# Author: Jordan Erasmus

THRESHOLD="${THRESHOLD:-80}"

# Validate the configured threshold
if ! [[ "$THRESHOLD" =~ ^[0-9]+$ ]] || (( THRESHOLD > 100 )); then
    echo "ERROR: Threshold must be a number between 0 and 100."
    exit 2
fi

# Retrieve root filesystem usage
if ! DF_OUTPUT=$(df -P /); then
    echo "ERROR: Unable to retrieve disk information."
    exit 2
fi

USAGE=$(awk 'NR==2 {gsub(/%/, "", $5); print $5}' <<< "$DF_OUTPUT")

# Validate the returned disk usage
if ! [[ "$USAGE" =~ ^[0-9]+$ ]]; then
    echo "ERROR: Unable to read disk usage."
    exit 2
fi

echo "=================================="
echo "       DISK MONITORING TOOL"
echo "=================================="

echo "Root filesystem usage: ${USAGE}%"
echo "Configured threshold: ${THRESHOLD}%"

if (( USAGE >= THRESHOLD )); then
    echo "WARNING: Disk usage has reached or exceeded the threshold!"
    exit 1
else
    echo "OK: Disk usage is within acceptable limits."
    exit 0
fi

