#!/bin/sh
# This script is called by post_init_hook.sh
# Be careful! Only if "/usr/local/openvswitch" exists, Run post_init_hook.sh 

#echo "Starting ZTPrun.sh"

# Make settings for connecting to the network
/usr/sbin/klish -q -s /mnt/udisk/ZTPrun.conf

# Wait rpc-api about 15 seconds
for i in $(seq 1 15); do
    echo -n "."
    sleep 1
done
# New Line
echo ""

# Clear cpu packet buffer
rm -rf /mnt/flash/mirror/*
/mnt/udisk/CPUpktCapture.py clear

# Make packet capture file under /mnt/flash/mirror/
/mnt/udisk/CPUpktCapture.py start

# Capture packet about 30 seconds
#for i in {1..30} Not work in sh without bash
for i in $(seq 1 30); do
    echo -n "."
    sleep 1
done
# New Line
echo ""

# Stop packet capture file under /mnt/flash/mirror/
/mnt/udisk/CPUpktCapture.py stop

# packet parser and make configure
/mnt/udisk/pktParserAndMakeConfig.sh
sync
sync
sleep 3

#reboot -f

/usr/sbin/klish -q -s /mnt/udisk/conn4net.conf

echo "End ZTP"
echo "End post INIT"

