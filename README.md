# sir-bash-a-lot
Some more bash scripts and miscellaneous stuff.

## ncurses_linux-server-control-panel.sh
Aims to put all the BS into one easy to use menu.

| Section  | Tools                               |
| -------- | ----------------------------------- |
| System   | update, uptime, memory, disk        |
| Network  | IP, ping, routing, open ports       |
| Docker   | list / restart containers           |
| Firewall | ufw status                          |
| Services | start/stop/restart systemd services |
| Logs     | browse log files                    |
| Disk     | quick usage analysis                |


**Proposed Features**
- System Update
- System Monitor
- Network Tools
- Docker Manager
- Firewall Status
- Service Manager
- Log Viewer
- Disk Usage Analyzer
- Reboot Server
- Shutdown Server
- Exit


**Usage:**
```
chmod +x server-dashboard.sh
./ncurses_linux-server-control-panel.sh
```
