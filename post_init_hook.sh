#!/bin/sh
# This script runs in the background, so you can exit it.

echo "Start post INIT ...."

USB_MOUNT_DIR="/mnt/udisk"
isUSB="false"
isZTP="false"
isDEFAULTCONF="false"
ZTPFILE="$USB_MOUNT_DIR/ZTPrun.sh"
STARTUP_CONFIG="/mnt/flash/startup-config.conf"
FACTORY_CONFIG="/mnt/flash/boot/.factory-config.conf"

# /mnt/flash/startup-config.conf file exists at this point
# Compare /mnt/flash/startup-config.conf and /mnt/flash/boot/.factory-config.conf 
diff $STARTUP_CONFIG $FACTORY_CONFIG > /dev/null 2>&1
isDEFAULTCONF=`[ $? -eq 0 ] && echo "true" || echo "false"`
if [ $isDEFAULTCONF == "false" ]; then
    echo "End post INIT"
    exit 0
fi

# Check mount USB Drive
echo -n "USB Drive "

if [ -d $USB_MOUNT_DIR ]; then
    echo "detected"
    isUSB="true"
else
    echo "not detected"
fi

# Check ZTP script
if [ $isUSB == "true" ]; then
    if [ -f "$ZTPFILE" ]; then
        isZTP="true"
    fi
fi

#echo "USB is $isUSB, ZTP is $isZTP"

# If ZTP script, run it
if [ $isDEFAULTCONF == "true" ] && [ $isZTP == "true" ]; then
    echo "ZTP inprogress......"
    $ZTPFILE &
else
    echo "End post INIT"
fi

