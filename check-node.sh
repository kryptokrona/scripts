#!/bin/bash

# Run as cronjob.
# Send to you own Discord server and a specific channel recommended
WEBHOOK_URL="https://discord.com/api/webhooks/< replace with your webhook>"
# Replace with your ID if you want ping on nick. Advanced - Developer Mode set Enabled.
# Go to profile picture > click the "....." and CopyID" should be a number of like 123455667888998888
PING="<@123455667888998888>"
DATE=$(date '+%F %T')
IP=$(ip a list eth0 | grep -E 'inet ' | awk -F " " '{ print $2 }' | awk -F "/" '{ print $1 }')

curl -s localhost:11898/getinfo | jq .status > nodestatus.json
CHECKNODE=$(cat nodestatus.json | tr -d '"')

if [[ $CHECKNODE == *"OK"* ]]; then
   echo -e "Node status: $CHECKNODE"
else
   MESSAGE="$PING :loudspeaker: $DATE WARNING Kryptokrona node IP $IP not working!\nStatus: ${CHECKNODE}\n"
   JSON="{\"content\": \"$MESSAGE\"}"
   curl -d "$JSON" -H "Content-Type: application/json" "$WEBHOOK_URL"
fi
