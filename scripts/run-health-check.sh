#!/usr/bin/env bash

# Linux Health Check Automation
# Author: Jordan Erasmus

set -u

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
HEALTH_SCRIPT="$SCRIPT_DIR/system-health.sh"

LOG_DIR="$HOME/.local/state/linux-admin-toolkit"
LOG_FILE="$LOG_DIR/system-health.log"

# Check that the health monitoring script exists
if [[ ! -f "$HEALTH_SCRIPT" ]]; then
    echo "ERROR: System health script not found."
    exit 2
fi

# Create the log directory if necessary
if ! mkdir -p "$LOG_DIR"; then
    echo "ERROR: Unable to create log directory."
    exit 2
fi

# Rotate the log if it reaches 1 MB
MAX_LOG_SIZE=1048576

if [[ -f "$LOG_FILE" ]]; then
    LOG_SIZE=$(stat -c '%s' "$LOG_FILE") || {
        echo "ERROR: Unable to check log file size."
        exit 2
    }

    if (( LOG_SIZE >= MAX_LOG_SIZE )); then
        ARCHIVE_FILE="$LOG_DIR/system-health-$(date '+%Y%m%d-%H%M%S').log"

        if ! mv -- "$LOG_FILE" "$ARCHIVE_FILE"; then
            echo "ERROR: Unable to archive previous log."
            exit 2
        fi

        echo "Previous log archived: $ARCHIVE_FILE"
    fi
fi

# Record the date and time
TIMESTAMP="$(date '+%Y-%m-%d %H:%M:%S')"

echo "Starting system health check..."

# Add a header to the log
{
    echo ""
    echo "======================================"
    echo "HEALTH CHECK STARTED: $TIMESTAMP"
    echo "======================================"
} >> "$LOG_FILE"

# Run the monitoring script and capture its output
if "$HEALTH_SCRIPT" >> "$LOG_FILE" 2>&1; then
    SCRIPT_STATUS=0
else
    SCRIPT_STATUS=$?
fi

# Add a summary to the log
{
    echo "======================================"
    echo "Health check completed: $TIMESTAMP"
    echo "Exit code: $SCRIPT_STATUS"
    echo "======================================"
    echo ""
} >> "$LOG_FILE"

echo "Health check completed."
echo "Log file: $LOG_FILE"
echo "Exit code: $SCRIPT_STATUS"

exit "$SCRIPT_STATUS"
