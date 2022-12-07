#!/bin/bash
NOW=$(date +%s)
DATE=$(date '+%F %T')

# Colors
RED='\033[1;31m'
YELLOW='\033[1;33m'
BLUE="\\033[38;5;27m"
SEA="\\033[38;5;49m"
GREEN='\033[1;32m'
CYAN='\033[1;36m'
NC='\033[0m'

#emoji codes
CHECK_MARK="${GREEN}\xE2\x9C\x94${NC}"
X_MARK="${RED}\xE2\x9C\x96${NC}"

tabs 25

# curl exists and runs ok

curl --version >/dev/null 2>&1
curl_ok=$?

[[ "$curl_ok" -eq 127 ]] && \
    echo "fatal: curl not installed" && exit 2

GETNODES=$(curl -s -k https://raw.githubusercontent.com/kryptokrona/kryptokrona-nodes-list/master/nodes.json | jq '.nodes[] | { url }' | grep url | awk -F ":" '{ print $2 }' | tr -d '" ' | tr -s '\n' ' ' )
NODES=( $GETNODES )
VERSION="1.0.1"
# Check Kryptokrona Daemon
echo -e ""
echo -e "$DATE"
echo -e "Node\tStatus\tSynced\tNode height\tNetwork\tConnection IN/OUT\tVersion\tFee"
echo -e "---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
for NODE in "${NODES[@]}" 
do
   curl -m 6 -s http://"$NODE":11898/getinfo -o $NODE-node
   if [ $? -eq 0 ] ; then
       STATUS=$(cat $NODE-node | jq ."status" | tr -d '"')
       if [[ "$STATUS" == "OK" ]] ; then
           NODESTATUS="${GREEN}$STATUS${NC} ${CHECK_MARK}"
       else
           NODESAATUS="${RED}$STATUS${NC} ${X_MARK}"
       fi
       SYNCED=$(cat $NODE-node | jq ."synced")
       if [[ "$SYNCED" == "true" ]] ; then
           NODESYNC="${GREEN}$SYNCDED${NC} ${CHECK_MARK}"
       else
           NODESSYNC="${RED}$SYNCED${NC} ${X_MARK}"
       fi
       NODEVERSION=$(cat $NODE-node | jq ."version" | tr -d '"')
       if [ "$VERSION" = "$NODEVERSION" ] ; then
           NODEVER="${GREEN}$NODEVERSION${NC} ${CHECK_MARK}"
       else
           NODEVER="${RED}$NODEVERSION${NC} ${X_MARK}"
       fi
       IN=$(cat $NODE-node | jq ."incoming_connections_count")
       if [ $IN -lt "1" ]; then
           NODEIN="${YELLOW}$IN${NC}"
       else
           NODEIN="${GREEN}$IN${NC}"
       fi
       OUT=$(cat $NODE-node | jq ."outgoing_connections_count")
       if [ $OUT -lt "1" ]; then
           NODEOUT="${YELLOW}$OUT${NC}"
       else
           NODEOUT="${GREEN}$OUT${NC}"
       fi
       NODEHEIGHT=$(cat $NODE-node | jq ."height")
       HEIGHT=$(cat $NODE-node | jq ."network_height")
       FEE=$(curl -m 3 -s -k http://"$NODE":11898/feeinfo | jq '.amount')
       echo -e "$NODE\t$NODESTATUS\t$NODESYNC\t$NODEHEIGHT\t$HEIGHT\t$NODEIN/$NODEOUT\t$NODEVER\t$FEE"
   else
       echo -e "${RED}$NODE${NC} ${X_MARK}"
   fi
rm -f *-node
done