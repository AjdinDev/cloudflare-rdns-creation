#!/bin/bash

# Variables
CLOUDFLARE_API_TOKEN="replace"
CLOUDFLARE_ZONE_ID="replace"
DOMAIN="static.example.com"
BASE_IP="1.2.3"
DRY_RUN=0
SLEEP=1

# Check for --dry-run argument
if [[ $1 == "--dry-run" ]]; then
    DRY_RUN=1
    echo "Running in DRY RUN mode. No changes will be made."
fi

# Decompose BASE_IP into its components
IFS='.' read -ra ADDR <<< "${BASE_IP}"

# Loop through IPs and create or simulate creation of records
for i in {0..255}; do
  IP="${BASE_IP}.${i}"
  RDNS="static.${i}.${ADDR[2]}.${ADDR[1]}.${ADDR[0]}.${DOMAIN}"

  echo "Processing IP: ${IP} with rDNS: ${RDNS}"

  if [[ $DRY_RUN -eq 1 ]]; then
      echo "DRY RUN: Would create DNS record for ${RDNS} pointing to ${IP}"
  else
      RESPONSE=$(curl -s -X POST "https://api.cloudflare.com/client/v4/zones/${CLOUDFLARE_ZONE_ID}/dns_records" \
       -H "Authorization: Bearer ${CLOUDFLARE_API_TOKEN}" \
       -H "Content-Type: application/json" \
       --data '{"type":"A","name":"'"${RDNS}"'","content":"'"${IP}"'","ttl":86400,"proxied":false}')

      # Check if the operation was successful based on the response
      SUCCESS=$(echo $RESPONSE | jq -r '.success')
      ERRORS=$(echo $RESPONSE | jq -r '.errors')

      if [[ $SUCCESS == "true" ]]; then
          echo "Successfully created DNS record for ${RDNS} pointing to ${IP}"
      else
          echo "Failed to create DNS record for ${RDNS} pointing to ${IP}"
          echo "Error: ${ERRORS}"
      fi
  fi

  # Sleep for a short time to avoid hitting rate limits (adjust as needed)
  sleep ${SLEEP}
done

echo "Operation completed!"
