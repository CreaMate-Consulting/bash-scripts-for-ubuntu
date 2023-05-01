#!/bin/bash
#
# Name:           wireguard-client_ubuntu22.04.sh
# Description:    This script installs Wireguard-Client on a Linux Ubuntu 22.04 system.
# Author:         OpenAI ChatGPT
# GitHub URI:     https://github.com/openai/
# License:        GPL v3 or later
# License URI:    https://www.gnu.org/licenses/gpl-3.0.de.html
#
# Execute command: wget "https://raw.githubusercontent.com/CreaMate-Consulting/bash-scripts-for-ubuntu/main/ubuntu22.04/Wireguard/wireguard-client_ubuntu22.04.sh" && bash wireguard-client_ubuntu22.04.sh

#

# Check if the user running the script is root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

#Update package list
apt update

# Add the WireGuard PPA
add-apt-repository ppa:wireguard/wireguard -y

# Update the system
apt update -y && sudo apt upgrade -y

# Install WireGuard
apt install wireguard -y

# Generate a new key pair for the client
umask 077
wg genkey | tee privatekey | wg pubkey > publickey

# Get the server's public key and IP address
read -p "Enter the server's public key: " server_public_key
read -p "Enter the server's IP address: " server_ip

# Create the WireGuard configuration file
tee /etc/wireguard/wg0.conf > /dev/null <<EOT
[Interface]
PrivateKey = $(cat privatekey)
Address = 10.0.0.2/24

[Peer]
PublicKey = $server_public_key
AllowedIPs = 0.0.0.0/0
Endpoint = $server_ip:51820
PersistentKeepalive = 15
EOT

# Start the WireGuard client
wg-quick up wg0

# Show the WireGuard interface status
wg show
