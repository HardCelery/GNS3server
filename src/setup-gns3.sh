#!/bin/bash

set -eux

# Update system
export DEBIAN_FRONTEND=noninteractive
apt-get update -y
apt-get upgrade -y

# Install necessary packages
apt-get install -y ubuntu-desktop gnome-terminal xterm wireshark docker.io bridge-utils

# Start Docker service
systemctl enable docker
systemctl start docker

# Install GNS3 GUI + server
apt-get install -y gns3-gui

# Allow non-root Wireshark usage
chmod +x /usr/bin/dumpcap
setcap cap_net_raw,cap_net_admin=eip /usr/bin/dumpcap

# Create directories
mkdir -p /home/ubuntu/GNS3/{projects,images,configs}
chown -R ubuntu:ubuntu /home/ubuntu/GNS3

# Ensure graphical login
systemctl set-default graphical.target

# Optional: Add desktop shortcut
sudo -u ubuntu mkdir -p /home/ubuntu/Desktop
cat <<EOF > /home/ubuntu/Desktop/gns3.desktop
[Desktop Entry]
Name=GNS3
Exec=gns3
Icon=gns3
Type=Application
Categories=Network;
EOF
chmod +x /home/ubuntu/Desktop/gns3.desktop
chown ubuntu:ubuntu /home/ubuntu/Desktop/gns3.desktop
