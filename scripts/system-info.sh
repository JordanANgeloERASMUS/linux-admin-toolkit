#!/bin/bash

# Linux System Information Tool
# Author: Jordan Erasmus

echo "=================================="
echo "      LINUX SYSTEM INFORMATION"
echo "=================================="

echo ""
echo "HOSTNAME:"
hostname

echo ""
echo "OPERATING SYSTEM:"
# shellcheck disable=SC1091
. /etc/os-release
echo "$PRETTY_NAME"

echo ""
echo "KERNEL VERSION:"
uname -r

echo ""
echo "CPU INFORMATION:"
lscpu | grep "Model name" | head -n 1

echo ""
echo "MEMORY USAGE:"
free -h

echo ""
echo "DISK USAGE:"
df -h /

echo ""
echo "SYSTEM UPTIME:"
uptime -p

echo ""
echo "=================================="
echo "SYSTEM CHECK COMPLETED"
echo "=================================="
