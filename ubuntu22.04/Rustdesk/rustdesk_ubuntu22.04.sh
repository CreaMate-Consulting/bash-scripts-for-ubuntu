#!/bin/bash
#
# Name:           rustdesk_ubuntu22.04.sh
# Description:    Install and configure Rustdesk-server on ubuntu 22 system
# Author:         Pascal Kray
# Author URI:     https://krapas170.de/
# GitHub URI:     https://github.com/krapas170/
# License:        GPL v3 or later
# License URI:    https://www.gnu.org/licenses/gpl-3.0.de.html
#
# Execute command: wget "https://raw.githubusercontent.com/CreaMate-Consulting/bash-scripts-for-ubuntu/main/ubuntu22.04/Rustdesk/rustdesk_ubuntu22.04.sh" && bash rustdesk_ubuntu22.04.sh
#

# Check if the user running the script is root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

#Update package list
apt update

# Install Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Install dependencies
apt install -y pkg-config libssl-dev libxcb-render0-dev libxcb-shape0-dev libxcb-xfixes0-dev libavcodec-dev libavformat-dev libswscale-dev libavdevice-dev libx11-dev libxkbfile-dev

# Download Rustdesk
curl -sSL https://github.com/rustdesk/rustdesk/releases/download/0.6.0/rustdesk-server-0.6.0-x86_64-unknown-linux-gnu.tar.gz | tar xz

# Move files to /opt/rustdesk
mkdir -p /opt/rustdesk
mv rustdesk-server-*/* /opt/rustdesk/

# Create a systemd service file
cat > /etc/systemd/system/rustdesk.service <<EOL
[Unit]
Description=Rustdesk server
After=network.target

[Service]
Type=simple
ExecStart=/opt/rustdesk/hbbs -r rustdesk.example.com:21116 --ipv6
Restart=always
User=root
Group=root

[Install]
WantedBy=multi-user.target
EOL

# Reload systemd and start Rustdesk
systemctl daemon-reload
systemctl enable rustdesk
systemctl start rustdesk
