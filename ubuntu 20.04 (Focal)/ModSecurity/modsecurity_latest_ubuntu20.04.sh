#!/bin/bash
#
# Name:           modsecurity_installer.sh
# Description:    This script installs ModSecurity on a Linux Ubuntu 20.04 system with Apache.
# Author:         OpenAI ChatGPT
# GitHub URI:     https://github.com/openai/
# License:        GPL v3 or later
# License URI:    https://www.gnu.org/licenses/gpl-3.0.de.html
#
# Execute command: wget "https://raw.githubusercontent.com/your-repo/bash-scripts-for-ubuntu/main/ubuntu%2020.04%20(Focal)/ModSecurity/modsecurity_installer.sh" && bash modsecurity_installer.sh
#

# Check if Apache is installed
if ! dpkg -l | grep apache2 > /dev/null; then
    echo "Apache is not installed. Installing..."
    sudo apt-get update
    sudo apt-get install -y apache2
else
    echo "Apache is already installed."
fi

# Install required dependencies
sudo apt-get install -y \
    libapache2-mod-security2 \
    libyajl-dev \
    libxml2-dev \
    libpcre3-dev \
    libcurl4-openssl-dev \
    libgeoip-dev \
    liblmdb-dev \
    libjansson-dev \
    libluajit-5.1-dev \
    libmaxminddb-dev

# Enable ModSecurity
sudo a2enmod security2
sudo a2enmod headers

# Configure ModSecurity
sudo mv /etc/modsecurity/modsecurity.conf-recommended /etc/modsecurity/modsecurity.conf
sudo sed -i 's/SecRuleEngine DetectionOnly/SecRuleEngine On/' /etc/modsecurity/modsecurity.conf

# Download and configure the OWASP ModSecurity Core Rule Set (CRS)
sudo apt-get install -y git
git clone https://github.com/coreruleset/coreruleset.git
sudo mv coreruleset /usr/share/modsecurity-crs
sudo mv /usr/share/modsecurity-crs/crs-setup.conf.example /usr/share/modsecurity-crs/crs-setup.conf

# Create and configure the ModSecurity Apache configuration file
sudo bash -c "cat > /etc/apache2/mods-available/security2.conf <<- EOM
<IfModule security2_module>
        # Default recommended configuration
        SecDataDir /var/cache/modsecurity
        IncludeOptional /etc/modsecurity/*.conf
        IncludeOptional /usr/share/modsecurity-crs/*.conf
        IncludeOptional /usr/share/modsecurity-crs/rules/*.conf
</IfModule>
EOM"

# Restart Apache
sudo systemctl restart apache2

echo "ModSecurity installation completed."
