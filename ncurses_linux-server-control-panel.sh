#!/bin/bash

BACKTITLE="Linux Server Control Panel"
HEIGHT=18
WIDTH=60
MENU_HEIGHT=10

pause(){
    read -p "Press Enter to continue..."
}

system_update(){
    sudo apt update
    sudo apt upgrade -y
    pause
}

system_monitor(){
    clear
    echo "SYSTEM INFO"
    echo "-----------------------"
    uptime
    echo
    free -h
    echo
    df -h
    echo
    top -n 1 | head -20
    pause
}

network_tools(){

CHOICE=$(dialog --clear \
--backtitle "$BACKTITLE" \
--title "Network Tools" \
--menu "Choose tool" \
15 50 6 \
1 "Show IP addresses" \
2 "Ping test" \
3 "Open ports" \
4 "Routing table" \
2>&1 >/dev/tty)

case $CHOICE in

1)
clear
ip a
pause
;;

2)
HOST=$(dialog --inputbox "Host to ping" 8 40 2>&1 >/dev/tty)
clear
ping -c 4 $HOST
pause
;;

3)
clear
ss -tulnp
pause
;;

4)
clear
ip route
pause
;;

esac
}

docker_menu(){

CHOICE=$(dialog --clear \
--backtitle "$BACKTITLE" \
--title "Docker Manager" \
--menu "Docker options" \
15 50 6 \
1 "List containers" \
2 "Running containers" \
3 "Restart container" \
4 "Docker system info" \
2>&1 >/dev/tty)

case $CHOICE in

1)
clear
docker ps -a
pause
;;

2)
clear
docker ps
pause
;;

3)
NAME=$(dialog --inputbox "Container name" 8 40 2>&1 >/dev/tty)
docker restart $NAME
pause
;;

4)
clear
docker system df
pause
;;

esac
}

log_viewer(){

FILE=$(dialog --inputbox "Log file path" 8 50 "/var/log/syslog" 2>&1 >/dev/tty)

dialog --textbox "$FILE" 20 80
}

firewall_status(){
clear
sudo ufw status verbose
pause
}

service_manager(){

SERVICE=$(dialog --inputbox "Service name" 8 40 2>&1 >/dev/tty)

CHOICE=$(dialog --menu "Service Action" 12 40 3 \
1 Start \
2 Stop \
3 Restart \
2>&1 >/dev/tty)

case $CHOICE in

1)
sudo systemctl start $SERVICE
;;

2)
sudo systemctl stop $SERVICE
;;

3)
sudo systemctl restart $SERVICE
;;

esac

pause
}

disk_usage(){
clear
du -sh /*
pause
}

while true
do

OPTION=$(dialog --clear \
--backtitle "$BACKTITLE" \
--title "Main Dashboard" \
--menu "Select option" \
$HEIGHT $WIDTH $MENU_HEIGHT \
1 "System Update" \
2 "System Monitor" \
3 "Network Tools" \
4 "Docker Manager" \
5 "Firewall Status" \
6 "Service Manager" \
7 "Log Viewer" \
8 "Disk Usage Analyzer" \
9 "Reboot Server" \
10 "Shutdown Server" \
11 "Exit" \
2>&1 >/dev/tty)

case $OPTION in

1)
system_update
;;

2)
system_monitor
;;

3)
network_tools
;;

4)
docker_menu
;;

5)
firewall_status
;;

6)
service_manager
;;

7)
log_viewer
;;

8)
disk_usage
;;

9)
sudo reboot
;;

10)
sudo shutdown now
;;

11)
clear
exit
;;

esac

done
