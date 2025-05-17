#!/bin/bash
set -e

# Update system
apt-get update -y
apt-get upgrade -y

# Install necessary packages
apt-get install -y python3-venv python3-pip qemu-system-x86 docker.io bridge-utils

# Start Docker service
systemctl enable docker
systemctl start docker

# Create GNS3 virtual environment
python3 -m venv /home/ubuntu/.env
source /home/ubuntu/.env/bin/activate

# Install latest gns3-server
pip install --upgrade pip
pip install gns3-server

# Create GNS3 config
mkdir -p /home/ubuntu/.config/GNS3
cat <<EOF > /home/ubuntu/.config/GNS3/gns3_server.conf
[Server]
host = 0.0.0.0
port = 3080
local = False
auth = False

[Qemu]
qemu_path = /usr/bin/qemu-system-x86_64

[Docker]
enable_docker = True
EOF

# Create systemd service
cat <<EOF | sudo tee /etc/systemd/system/gns3server.service
[Unit]
Description=GNS3 Server with virtual environment
After=network.target docker.service

[Service]
Type=simple
User=ubuntu
WorkingDirectory=/home/ubuntu
ExecStart=/bin/bash -c 'source /home/ubuntu/.env/bin/activate && exec gns3server --config /home/ubuntu/.config/GNS3/gns3_server.conf'
Restart=always

[Install]
WantedBy=multi-user.target
EOF

# Fix permissions for GNS3 config directory
chown -R ubuntu:ubuntu /home/ubuntu/.config/GNS3

# Reload systemd and start service
systemctl daemon-reload
systemctl enable gns3server
systemctl start gns3server
