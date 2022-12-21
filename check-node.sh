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
   MESSAGE="$PING :loudspeaker: $DATE WARNING Kryptokrona node IP $IP not working!\nStatus: Down\n Will try to restart."
   JSON="{\"content\": \"$MESSAGE\"}"
   curl -d "$JSON" -H "Content-Type: application/json" "$WEBHOOK_URL"
   # Get process ID of kryptokrona node
   pid=$(pidof kryptokronad)
   # Try to kill node nicely and wait 10s
   kill $pid
   sleep 10

   # Check if pid has changed
   pid_new=$(pidof kryptokronad)
   if [ "$pid_new" = "$pid" ]; then
      echo "Killing with -9"
      kill -9 $pid
   fi
   if [ -z "$pid" ]; then
       screen -d -m ./kryptokrona/kryptokronad --enable-cors=* --enable-blockexplorer --rpc-bind-ip=0.0.0.0 --rpc-bind-port=11898
   fi
   sleep 30
   curl -s localhost:11898/getinfo | jq .status > nodestatus.json
   CHECKNODE=$(cat nodestatus.json | tr -d '"')
   if [[ $CHECKNODE == *"OK"* ]]; then
       MESSAGE="$PING :loudspeaker: $DATE Kryptokrona node IP $IP Fixed!\nStatus: $CHECKNODE"
       JSON="{\"content\": \"$MESSAGE\"}"
       curl -d "$JSON" -H "Content-Type: application/json" "$WEBHOOK_URL"

   fi
fi
