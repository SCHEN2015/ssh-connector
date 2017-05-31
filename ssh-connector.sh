#!/bin/bash

# Owner: Charles Shih
# Email: N/A

# Version:
# v0.1  cshi002 2014/07/22      init version
# v0.2  cshi002 2015/03/24      support ignore case for hostname


if [ $# -lt 1 ]; then
        echo "Usage: $0 hostname [m | makeauthorized]"
        exit
fi

HOST=$1

PARAM=`grep -i "^\<$HOST\>" ~/.host.exp | awk '{print $2,$3,$4;exit}'`

if [ -z "$PARAM" ]; then
        echo -e "Error: Can not find hostname '$1' in ~/.host.exp\n"
#       echo -e "Trying to get ipaddr..."
#       IPADDR=`ping $HOST -c 1 | grep "$HOST.*(.*)" | grep -v ":" | cut -d "(" -f 2 | cut -d ")" -f 1`
#       echo $IPADDR
#       if [ -z "IPADDR" ]; then
                exit 1
#       fi
fi

HOSTIP=`echo $PARAM | cut -d " " -f 1`
USERNAME=`echo $PARAM | cut -d " " -f 2`


if [ "$2" == "m" ]
then
        ssh-pushkey.sh $USERNAME $HOSTIP
        exit 0
fi


echo "ssh $USERNAME@$HOSTIP ..."

# Set title
echo -ne "\033]0;$HOST [$HOSTIP]\007"

ssh $USERNAME@$HOSTIP

echo -ne "\033]0;`hostname`\007"

exit 0
