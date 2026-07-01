#!/usr/bin/env bash
set -euo pipefail

echo "=============================================="
echo " AWS EC2 Ubuntu Performance Optimizer"
echo "=============================================="

if [[ $EUID -ne 0 ]]; then
    echo "Run this script as root."
    exit 1
fi

echo
echo "[1/10] Updating packages..."
apt update
apt -y upgrade
apt -y autoremove

echo
echo "[2/10] Installing performance tools..."
apt install -y \
    irqbalance \
    htop \
    btop \
    iotop \
    iftop \
    sysstat \
    nvme-cli \
    curl \
    wget \
    unzip

systemctl enable irqbalance
systemctl restart irqbalance

echo
echo "[3/10] Enabling weekly SSD TRIM..."
systemctl enable fstrim.timer
systemctl start fstrim.timer

echo
echo "[4/10] Applying kernel tuning..."

cat >/etc/sysctl.d/99-performance.conf <<'EOF'
#######################################################
# Memory
#######################################################
vm.swappiness=10
vm.vfs_cache_pressure=50
vm.dirty_ratio=15
vm.dirty_background_ratio=5

#######################################################
# Files
#######################################################
fs.file-max=2097152

#######################################################
# Networking
#######################################################
net.core.somaxconn=4096
net.core.netdev_max_backlog=8192

net.ipv4.ip_local_port_range=1024 65535
net.ipv4.tcp_max_syn_backlog=8192
net.ipv4.tcp_tw_reuse=1
net.ipv4.tcp_mtu_probing=1
net.ipv4.tcp_fastopen=3

#######################################################
# TCP BBR
#######################################################
net.core.default_qdisc=fq
net.ipv4.tcp_congestion_control=bbr
EOF

sysctl --system

echo
echo "[5/10] Increasing file descriptor limits..."

cp /etc/security/limits.conf /etc/security/limits.conf.bak.$(date +%F-%H%M%S)

grep -q "1048576" /etc/security/limits.conf || cat >> /etc/security/limits.conf <<EOF

# Performance tuning
* soft nofile 1048576
* hard nofile 1048576
root soft nofile 1048576
root hard nofile 1048576
EOF

mkdir -p /etc/systemd/system.conf.d

cat >/etc/systemd/system.conf.d/limits.conf <<EOF
[Manager]
DefaultLimitNOFILE=1048576
EOF

systemctl daemon-reexec

echo
echo "[6/10] Optimizing ext4 mount options..."

ROOT_UUID=$(findmnt -no UUID /)

cp /etc/fstab /etc/fstab.bak.$(date +%F-%H%M%S)

if ! grep -q "noatime" /etc/fstab; then
    sed -i 's/errors=remount-ro/errors=remount-ro,noatime/' /etc/fstab || true
fi

echo
echo "[7/10] Checking I/O scheduler..."

if [[ -f /sys/block/nvme0n1/queue/scheduler ]]; then
    cat /sys/block/nvme0n1/queue/scheduler
fi

echo
echo "[8/10] Checking BBR..."

sysctl net.ipv4.tcp_congestion_control

echo
echo "[9/10] System information"

echo
echo "CPU:"
lscpu | grep "Model name"

echo
echo "Memory:"
free -h

echo
echo "Disk:"
lsblk

echo
echo "[10/10] Finished"

echo
echo "=============================================="
echo "Optimization complete."
echo
echo "Recommended next steps:"
echo
echo "  • reboot the server"
echo "  • tune MariaDB/PostgreSQL"
echo "  • tune Nginx"
echo "  • enable Redis"
echo "=============================================="
