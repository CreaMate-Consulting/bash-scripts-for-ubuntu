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

# Install Rustdesk over installation script
wget https://raw.githubusercontent.com/dinger1986/rustdeskinstall/master/install.sh
chmod +x install.sh
./install.sh

# The script above is a ready-made and tested script from Rustdesk's Github page. No guarantee that the installation script will work.



# Enable and configure Firewall
ufw allow 21115:21119/tcp
ufw allow 8000/tcp
ufw allow 21116/udp
sudo ufw enable
