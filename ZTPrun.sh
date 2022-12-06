#!/bin/sh
# This script is called by post_init_hook.sh
# Be careful! Only if "/usr/local/openvswitch" exists, Run post_init_hook.sh 

#echo "Starting ZTPrun.sh"
if [ -z $ZTP_POS ]; then
    ZTP_POS=`pwd`
    export ZTP_POS
fi
echo "ZTPrun.sh" $ZTP_POS
CONN4NET_FILE=$ZTP_POS/conn4net.conf
export CONN4NET_FILE

SYSID=`cat /tmp/oem_info | grep hardware_type | awk -F'[ -]' '{print $NF}'`
if [ $SYSID == "BP" ]; then
    SYSID=`cat /tmp/oem_info | grep hardware_type | awk -F'[ -]' '{print $(NF-1)}'`
fi
echo $SYSID

case $SYSID in
    8T4X)
        echo "SYSTEM is $SYSID. ZTP Port is eth-0-1"
        ZTP_PORT="0-1"
        ;;
    24P4XJ)
        echo "SYSTEM is $SYSID. ZTP Port is eth-0-25"
        ZTP_PORT="0-25"
        ;;
    48HP)
        echo "SYSTEM is $SYSID. ZTP Port is eth-0-49"
        ZTP_PORT="0-49"
        ;;
    24T4X)
        echo "SYSTEM is $SYSID. ZTP Port is eth-0-25"
        ZTP_PORT="0-25"
        ;;
    48X6Q | SFC9500A)
        echo "SYSTEM is $SYSID."
        cp -f $ZTP_POS/startup-config.conf /mnt/flash/startup-config.conf
        touch $ZTP_POS/ztp_complete
        sync
        sleep 3
        sync
        reboot -f
        ;;
    *)
        echo "SYSTEM is unknown. ZTP Port is eth-0-1"
        ZTP_PORT="0-1"
        ;;
esac

echo "ZTP_PORT is eth-$ZTP_PORT"
export ZTP_PORT

sed -in "s/\(monitor .* source .* eth-\)\(.*\)/\1$ZTP_PORT rx/" $ZTP_POS/ZTPrun.conf

# Make settings for connecting to the network
/usr/sbin/klish -q -s $ZTP_POS/ZTPrun.conf

# Wait rpc-api about 15 seconds
for i in $(seq 1 10); do
    echo -n "."
    sleep 1
done
# New Line
echo ""

# Clear cpu packet buffer
rm -rf /mnt/flash/mirror/*
$ZTP_POS/CPUpktCapture.py clear

# Make packet capture file under /mnt/flash/mirror/
$ZTP_POS/CPUpktCapture.py start

# Capture packet about 30 seconds
#for i in {1..30} Not work in sh without bash
for i in $(seq 1 20); do
    echo -n "."
    sleep 1
done
# New Line
echo ""

# Stop packet capture file under /mnt/flash/mirror/
$ZTP_POS/CPUpktCapture.py stop

# packet parser and make configure
$ZTP_POS/pktParserAndMakeConfig.sh
RESULT=$?
echo "pktParse result is $RESULT"
sync
sync
sleep 3

#reboot -f

if [ -f $CONN4NET_FILE ]; then
    /usr/sbin/klish -q -s $CONN4NET_FILE
else
    /usr/sbin/klish -q -s /mnt/flash/boot/.factory-config.conf
fi

echo "End ZTP"
echo "End post INIT"

