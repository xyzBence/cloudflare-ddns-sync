# Cloudflare DDNS Updater

A simple dynamic DNS (DDNS) updater script that updates a Cloudflare DNS A-record to match your current public IP address. Ideal for home servers, VPNs, and other self-hosted services with a dynamic IP.

## Features

- Detects public IP via [ipify](https://api.ipify.org)
- Updates Cloudflare DNS A-record via API
- Uses systemd `timer` to check every minute
- Lightweight, simple, and script-based
- Includes auto-installation script

## Requirements

- A Linux system with `bash`, `curl`, `systemd`
- A Cloudflare domain with DNS A-record already created
- A Cloudflare API token with permissions to **Edit DNS**
- (Optional) `jq` installed for JSON parsing (used during setup/diagnostics)

## 🔐 Creating a Cloudflare API Token

1. Go to [Cloudflare API Tokens](https://dash.cloudflare.com/profile/api-tokens)
2. Click `Create Token`
3. Select the `Edit zone DNS` template
4. Permissions:
   - Zone → DNS → **Edit**
5. Zone Resources:
   - Include → Specific zone → *your domain (e.g. example.com)*
6. Click `Continue`, then `Create Token`
7. Copy the token (you won’t be able to see it again)

## 🌐 Getting the Zone ID and Record ID

You will need:

- Your **Zone ID** (associated with your domain)
- The **Record ID** (associated with the A-record you want to update)

To get them, run:

```bash
curl -s -X GET "https://api.cloudflare.com/client/v4/zones/YOUR_ZONE_ID/dns_records" \
  -H "Authorization: Bearer YOUR_API_TOKEN" \
  -H "Content-Type: application/json" | jq '.result[] | {id, name, type, content}'
```

You can find the Zone ID in your Cloudflare dashboard under:
> Domain → Overview → API → Zone ID

## 🔧 Installation

1. Clone this repository:

```bash
git clone https://github.com/xyzBence/cloudflare-ddns-sync.git
cd cloudflare-ddns-sync
```

2. Run the installer script:

```bash
chmod +x install.sh
./install.sh
```

3. Edit the config in the script:

```bash
sudo nano /opt/cloudflare-ddns-updater/update-dns.sh
```

Fill in:

```bash
API_TOKEN=""
ZONE_ID=""
RECORD_ID=""
RECORD_NAME=""
```

4. That's it! The systemd timer is now running and will check every minute.
