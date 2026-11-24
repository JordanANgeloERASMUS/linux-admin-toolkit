
# Linux Administration Command Reference

## System Information

| Command | Description |
|---|---|
| uname -r | Kernel version |
| hostname | System hostname |
| lscpu | CPU information |
| free -h | Memory usage |
| df -h | Disk usage |
| uptime | System uptime |

## Networking

| Command | Description |
|---|---|
| ip addr | Network interfaces |
| ip route | Routing table |
| ping | Connectivity testing |
| ss -tulnp | Listening network sockets |
| curl -I | HTTP response headers |

## Storage

| Command | Description |
|---|---|
| lsblk | Block devices |
| du -sh | Directory size |
| mount | Mounted filesystems |

## Service Management

| Command | Description |
|---|---|
| systemctl status | Check service status |
| systemctl restart | Restart service |
| journalctl -xe | Inspect system logs |
