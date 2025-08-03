#!/bin/bash

# Cloudflare API Configuration - fill these with your own values
API_TOKEN=""
ZONE_ID=""
RECORD_ID=""
RECORD_NAME=""

while true; do
    NEW_IP=$(curl -s https://api.ipify.org)
    if [ -z "$NEW_IP" ]; then
        echo "Error: Could not retrieve current IP!" >&2
        sleep 60
        continue
    fi

    CURRENT_IP=$(dig +short "$RECORD_NAME" A)
    if [ -z "$CURRENT_IP" ]; then
        echo "Warning: Could not retrieve current IP from DNS, updating to: $NEW_IP" >&2
        CURRENT_IP=""
    fi

    if [ "$NEW_IP" != "$CURRENT_IP" ] || [ -z "$CURRENT_IP" ]; then
        RESPONSE=$(curl -s -X PUT "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records/$RECORD_ID" \
        -H "Authorization: Bearer $API_TOKEN" \
        -H "Content-Type: application/json" \
        --data "{\"type\":\"A\",\"name\":\"$RECORD_NAME\",\"content\":\"$NEW_IP\",\"ttl\":120,\"proxied\":false}")
        if echo "$RESPONSE" | grep -q '"success":true'; then
            echo "Successfully updated DNS record. New IP: $NEW_IP"
        else
            echo "Error during update: $RESPONSE" >&2
        fi
    else
        echo "No change. IP is still $NEW_IP"
    fi

    sleep 60
done
