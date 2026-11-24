
#!/bin/bash

# Basic Linux Disk Monitoring Tool

THRESHOLD=80

USAGE=$(df / | awk 'NR==2 {gsub("%",""); print $5}')

echo "=================================="
echo "       DISK MONITORING TOOL"
echo "=================================="

echo "Root filesystem usage: ${USAGE}%"

if [ "$USAGE" -ge "$THRESHOLD" ]; then
    echo "WARNING: Disk usage is above ${THRESHOLD}%!"
else
    echo "Disk usage is within acceptable limits."
fi
