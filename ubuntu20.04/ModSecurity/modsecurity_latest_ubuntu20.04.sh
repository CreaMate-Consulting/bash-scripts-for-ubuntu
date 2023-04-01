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

# Check if Apache is installed
if ! dpkg -l | grep apache2 > /dev/null; then
    echo "Apache is not installed. Installing..."
    apt-get update
    apt-get install -y apache2
else
    echo "Apache is already installed."
fi

# Install required dependencies
apt-get install -y \
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
a2enmod security2
a2enmod headers

# Configure ModSecurity
mv /etc/modsecurity/modsecurity.conf-recommended /etc/modsecurity/modsecurity.conf
sed -i 's/SecRuleEngine DetectionOnly/SecRuleEngine On/' /etc/modsecurity/modsecurity.conf

# Download and configure the OWASP ModSecurity Core Rule Set (CRS)
apt-get install -y git
git clone https://github.com/coreruleset/coreruleset.git
mv coreruleset /usr/share/modsecurity-crs
mv /usr/share/modsecurity-crs/crs-setup.conf.example /usr/share/modsecurity-crs/crs-setup.conf

# Create and configure the ModSecurity Apache configuration file
bash -c "cat > /etc/apache2/mods-available/security2.conf <<- EOM
<IfModule security2_module>
        # Default recommended configuration
        SecDataDir /var/cache/modsecurity
        IncludeOptional /etc/modsecurity/*.conf
        IncludeOptional /usr/share/modsecurity-crs/*.conf
        IncludeOptional /usr/share/modsecurity-crs/rules/*.conf
</IfModule>
EOM"

# Restart Apache
systemctl restart apache2

echo "ModSecurity installation completed."
