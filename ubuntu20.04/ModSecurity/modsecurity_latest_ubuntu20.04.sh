#!/bin/bash
#
# Name:           modsecurity_latest_ubuntu20.04.sh
# Description:    This script installs ModSecurity on a Linux Ubuntu 20.04 system with Apache.
# Author:         OpenAI ChatGPT
# GitHub URI:     https://github.com/openai/
# License:        GPL v3 or later
# License URI:    https://www.gnu.org/licenses/gpl-3.0.de.html
#
# Execute command: wget "https://raw.githubusercontent.com/CreaMate-Consulting/bash-scripts-for-ubuntu/main/ubuntu20.04/ModSecurity/modsecurity_latest_ubuntu20.04.sh" && bash modsecurity_latest_ubuntu20.04.sh
#

# Check if the user running the script is root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi

#Update package list
apt update

# Check if Apache is installed
if ! dpkg -l | grep apache2 > /dev/null; then
    echo "Apache is not installed. Installing..."
    sleep 5
    apt-get update
    apt-get install -y apache2
else
    echo "Apache is already installed."
    sleep 5
fi

# install Apache and ModSecurity
apt-get install -y libapache2-mod-security2

# enable ModSecurity module
a2enmod security2

# restart Apache
service apache2 restart

# rename ModSecurity config file
mv /etc/modsecurity/modsecurity.conf-recommended /etc/modsecurity/modsecurity.conf

# edit ModSecurity config file
sed -i 's/SecRuleEngine DetectionOnly/SecRuleEngine On/g' /etc/modsecurity/modsecurity.conf
sed -i 's/SecAuditLogParts ABDEFHIJZ/SecAuditLogParts ABCEFHJKZ/g' /etc/modsecurity/modsecurity.conf

# create directory for Core Rule Set files
mkdir /etc/apache2/modsecurity-crs/

# download and extract Core Rule Set
wget https://github.com/coreruleset/coreruleset/archive/v3.3.0.tar.gz
tar xvf v3.3.0.tar.gz
mv coreruleset-3.3.0/ /etc/apache2/modsecurity-crs/

# rename Core Rule Set setup file
mv /etc/apache2/modsecurity-crs/coreruleset-3.3.0/crs-setup.conf.example /etc/apache2/modsecurity-crs/coreruleset-3.3.0/crs-setup.conf

# edit Apache configuration file to include Core Rule Set
sed -i '/IncludeOptional \/usr\/share\/modsecurity-crs\/\*.load/d' /etc/apache2/mods-enabled/security2.conf
echo 'IncludeOptional /etc/apache2/modsecurity-crs/coreruleset-3.3.0/crs-setup.conf' >> /etc/apache2/mods-enabled/security2.conf
echo 'IncludeOptional /etc/apache2/modsecurity-crs/coreruleset-3.3.0/rules/*.conf' >> /etc/apache2/mods-enabled/security2.conf

# test Apache configuration
apache2ctl -t

# restart Apache after 10 seconds
sleep 10

service apache2 restart
service apache2 status

echo "ModSecurity installation completed."
sleep 5
