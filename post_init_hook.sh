#!/bin/sh
# This script runs in the background, so you can exit it.

echo "Start post INIT ...."

USB_MOUNT_DIR="/mnt/udisk"
ZTP_DIR="/mnt/flash/ztp"
ZTP_POS=""
isUSB="false"
isZTP="false"
isDEFAULTCONF="false"
ZTPFILE="$USB_MOUNT_DIR/ZTPrun.sh"
STARTUP_CONFIG="/mnt/flash/startup-config.conf"
FACTORY_CONFIG="/mnt/flash/boot/.factory-config.conf"

# Check mount USB Drive
echo -n "USB Drive "

if [ -d $USB_MOUNT_DIR ]; then
    echo "detected"
    isUSB="true"
    ZTP_POS=$USB_MOUNT_DIR
else
    echo "not detected"
    isUSB="false"
    if [ -d $ZTP_DIR ]; then
        ZTP_POS=$ZTP_DIR
    fi
fi

export ZTP_POS
echo $ZTP_POS
ZTPFILE="$ZTP_POS/ZTPrun.sh"


# /mnt/flash/startup-config.conf file exists at this point
# Compare /mnt/flash/startup-config.conf and /mnt/flash/boot/.factory-config.conf 
if [ -f $STARTUP_CONFIG ]; then
    diff $STARTUP_CONFIG $FACTORY_CONFIG > /dev/null 2>&1
    isDEFAULTCONF=`[ $? -eq 0 ] && echo "true" || echo "false"`
else
    isDEFAULTCONF="true"
fi
if [ $isDEFAULTCONF == "false" ]; then
    if [ -f $ZTP_POS/ztp_complete ]; then
        rm -f $ZTP_POS/ztp_complete
        if [ -f $ZTP_POS/ztp_post_proc.sh ]; then
            $ZTP_POS/ztp_post_proc.sh
        fi
    fi
    echo "End post INIT"
    exit 0
fi

# Check ZTP script
if [ -f "$ZTPFILE" ]; then
    isZTP="true"
fi

echo "USB is $isUSB, ZTP is $isZTP"

# If ZTP script, run it
if [ $isDEFAULTCONF == "true" ] && [ $isZTP == "true" ]; then
    echo "ZTP inprogress......"
    $ZTPFILE &
else
    echo "End post INIT"
fi

