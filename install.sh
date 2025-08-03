#!/bin/bash

echo "Installing Cloudflare DDNS Updater..."

# Create target directory
sudo mkdir -p /opt/cloudflare-ddns-updater
sudo cp update-dns.sh /opt/cloudflare-ddns-updater/
sudo chmod +x /opt/cloudflare-ddns-updater/update-dns.sh

# Replace USER in service file
USER_NAME=$(whoami)
sed "s|REPLACE_WITH_YOUR_USERNAME|$USER_NAME|g" update-dns.service | sudo tee /etc/systemd/system/update-dns.service > /dev/null
sudo cp update-dns.timer /etc/systemd/system/

# Reload systemd and enable timer
sudo systemctl daemon-reexec
sudo systemctl enable --now update-dns.timer

echo "Installation complete."
echo "Please edit /opt/cloudflare-ddns-updater/update-dns.sh and fill in your API_TOKEN, ZONE_ID, RECORD_ID, and RECORD_NAME."
