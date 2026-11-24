#!/usr/bin/env bash

# Linux System Health Monitoring Tool
# Author: Jordan Erasmus

WARNING_THRESHOLD=80
CRITICAL_THRESHOLD=95

OVERALL_STATUS=0

# Check CPU load relative to available CPU cores
CPU_CORES=$(getconf _NPROCESSORS_ONLN)
LOAD_1MIN=$(awk '{print $1}' /proc/loadavg)

CPU_LOAD=$(awk -v avg="$LOAD_1MIN" -v cores="$CPU_CORES" \
    'BEGIN {printf "%.0f", (avg / cores) * 100}')

# Check memory usage
read -r MEM_TOTAL MEM_AVAILABLE < <(
    awk '
        /^MemTotal:/ {total=$2}
        /^MemAvailable:/ {available=$2}
        END {print total, available}
    ' /proc/meminfo
)

MEMORY_USAGE=$(awk -v total="$MEM_TOTAL" -v available="$MEM_AVAILABLE" \
    'BEGIN {printf "%.0f", ((total - available) / total) * 100}')

# Check root filesystem usage
DISK_USAGE=$(df -P / | awk 'NR==2 {gsub(/%/, "", $5); print $5}')

# Validate collected metrics
if ! [[ "$CPU_LOAD" =~ ^[0-9]+$ ]] ||
   ! [[ "$MEMORY_USAGE" =~ ^[0-9]+$ ]] ||
   ! [[ "$DISK_USAGE" =~ ^[0-9]+$ ]]; then
    echo "ERROR: Unable to collect system health information."
    exit 3
fi

# Display the status of an individual metric
check_metric() {
    local name="$1"
    local value="$2"

    if (( value >= CRITICAL_THRESHOLD )); then
        printf "%-25s %s%% - CRITICAL\n" "$name" "$value"
        OVERALL_STATUS=2
    elif (( value >= WARNING_THRESHOLD )); then
        printf "%-25s %s%% - WARNING\n" "$name" "$value"

        if (( OVERALL_STATUS < 1 )); then
            OVERALL_STATUS=1
        fi
    else
        printf "%-25s %s%% - OK\n" "$name" "$value"
    fi
}

echo "======================================"
echo "       LINUX SYSTEM HEALTH CHECK"
echo "======================================"

echo ""
echo "SYSTEM METRICS:"
echo "CPU cores detected:       $CPU_CORES"
echo "CPU load (1-minute):      $LOAD_1MIN"

check_metric "CPU load level" "$CPU_LOAD"
check_metric "Memory usage" "$MEMORY_USAGE"
check_metric "Disk usage" "$DISK_USAGE"

echo ""
echo "SYSTEM UPTIME:"
uptime -p

echo ""
echo "======================================"

case "$OVERALL_STATUS" in
    0)
        echo "OVERALL STATUS: HEALTHY"
        ;;
    1)
        echo "OVERALL STATUS: WARNING"
        ;;
    2)
        echo "OVERALL STATUS: CRITICAL"
        ;;
esac

echo "======================================"

exit "$OVERALL_STATUS"
