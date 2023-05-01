#!/bin/bash
#
# Name:           lamp_ubuntu22.04.sh
# Description:    This script installs LAMP-Stack (Linux, Apache, MySQL und PHP) on a Linux Ubuntu 22.04 system.
# Author:         OpenAI ChatGPT
# GitHub URI:     https://github.com/openai/
# License:        GPL v3 or later
# License URI:    https://www.gnu.org/licenses/gpl-3.0.de.html
#
# Execute command: wget "https://raw.githubusercontent.com/CreaMate-Consulting/bash-scripts-for-ubuntu/main/ubuntu22.04/LAMP/lamp_ubuntu22.04.sh" && bash lamp_ubuntu22.04.sh

#

# Check if the user running the script is root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

#Update package list
apt update

# Apache2-Webserver installieren
sudo apt install -y apache2

# MySQL-Datenbankserver installieren
sudo apt install -y mysql-server

# PHP und zugehörige Module installieren
sudo apt install -y php libapache2-mod-php php-mysql php-cli php-json php-xml php-gd php-mbstring

# Apache2-Server neu starten, um Änderungen wirksam zu machen
sudo systemctl restart apache2

# Den Status des Apache2-Webservers überprüfen
sudo systemctl status apache2
