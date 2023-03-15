#!/bin/bash

# listen to udp port 9 for packets & check if it is a magic packet
while true
do
        nc-openbsd -dnlu -p 9 | stdbuf -o0 xxd -c 6 -p -l 12 | stdbuf -o0 grep -v 'ffffffffffff' | while read
        do
                mac="${REPLY:0:2}:${REPLY:2:2}:${REPLY:4:2}:${REPLY:6:2}:${REPLY:8:2}:${REPLY:10:2}"
                echo "Got triggered with MAC address $mac"

                # compare the MAC address with the magic packet
                if [ "$mac" == "<VM MAC ADDRESS>" ] 
                then
                        state=$(virsh list --all|awk -v vm=<VM NAME> '{ if ($2 == vm ) print $3 }')
                        echo "<VM NAME> in $state state"

                        # dependent of the state, resume, start or nothing
                        [ $state == "paused" ] && virsh -q resume <VM NAME> && virsh domtime --domain <VM NAME> --now
                        [ $state == "shut" ] && virsh -q start <VM NAME>
                        [ $state == "pmsuspended" ] && virsh dompmwakeup <VM NAME>
                        [ $state == "running" ] && echo Nothing to do <VM NAME> is already running
                fi
        done
done
