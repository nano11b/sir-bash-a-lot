# sir-bash-a-lot
Some more bash scripts and miscellaneous stuff.

## ncurses_linux-server-control-panel.sh
Aims to put all the BS into one easy to use menu.

### Prerequisites 
- Debian/Ubuntu/Mint: ``sudo apt install libncurses5-dev libncursesw5-dev``.
- RedHat/CentOS/Fedora: ``sudo yum install ncurses-devel``.
- macOS: Install via Homebrew: ``brew install ncurses``.


### Features
| Section  | Tools                               |
| -------- | ----------------------------------- |
| System   | update, uptime, memory, disk        |
| Network  | IP, ping, routing, open ports       |
| Docker   | list / restart containers           |
| Firewall | ufw status                          |
| Services | start/stop/restart systemd services |
| Logs     | browse log files                    |
| Disk     | quick usage analysis                |


**Features (extended)**
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

**To Be Added**
- live htop dashboard
- fail2ban viewer
- docker compose manager
- wireguard status
- backup manager
- log search
- package installer


**Usage:**
```
chmod +x server-dashboard.sh
./ncurses_linux-server-control-panel.sh
```
