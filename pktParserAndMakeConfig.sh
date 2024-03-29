#!/bin/sh
echo "Start pktParseAdnMakeConfig.sh $ZTP_POS $ZTP_PORT"

PKT_FILE=/mnt/flash/mirror/MirCpuPkt*
if [ -z $CONN4NET_FILE ]; then
    CONN4NET_FILE=$ZTP_POS/conn4net.conf
fi
PROTO_OSPF=89
AREA_IDS=""
NET_MASKS=""
IPV4_MASK=32

# Check File exist and size
if [ -f $PKT_FILE ]; then
    PKT_FILE_SIZE=`wc -c $PKT_FILE | cut -d' ' -f1`
fi

rm -f $CONN4NET_FILE

if [ $PKT_FILE_SIZE -lt 10 ]; then
    exit 9
fi

VLAN_LIST=`cat $PKT_FILE | grep -i -B2 "Protocol is 89" | awk '/VLAN/{ sub(",", "", $3); vlans[$3]++ } END { for (vlan in vlans) {printf("%s ", vlan) }}'`

#VLAN_LIST=""
if [ ${#VLAN_LIST} -lt 1 ]; then
    exit 99
fi

# Remove last character. aka space
VLAN_RANGE=${VLAN_LIST:0:$((${#VLAN_LIST}-1))}

echo -e "!\nvlan range ${VLAN_RANGE// /,}\n!" > $CONN4NET_FILE
echo -e "!\ninterface eth-$ZTP_PORT" >> $CONN4NET_FILE
echo -e " switchport mode trunk" >> $CONN4NET_FILE

for vlan in $VLAN_LIST; do
    echo -e " switchport trunk allowed vlan add $vlan" >> $CONN4NET_FILE
done

for vlan in $VLAN_LIST; do
    PKT_LINES=`cat $PKT_FILE | grep -i "8100 [0-9a-f]$(printf '%03x' $vlan)" -n | cut -d: -f1 | awk '{ lines[$1] } END { for (line in lines) {printf("%s ", line) }}'`
    for line in $PKT_LINES; do
        PROTO=`awk -v line=$line '{ if(NR == line+1) print $6 }' $PKT_FILE`
        PROTOCOL=$(( 0x${PROTO} & 0xFF ))
        if [ $PROTOCOL == $PROTO_OSPF ]; then
            AREA_HIGH=`awk -v line=$line '{ if(NR == line+2) print $8 }' $PKT_FILE`
            AREA_LOW=`awk -v line=$line '{ if(NR == line+3) print $1 }' $PKT_FILE`
            AREA_ID=$(( 0x${AREA_HIGH} << 16 | 0x${AREA_LOW} ))
            MASK_HIGH=`awk -v line=$line '{ if(NR == line+3) print $8 }' $PKT_FILE`
            MASK_LOW=`awk -v line=$line '{ if(NR == line+4) print $1 }' $PKT_FILE`
            MASK=`printf "%08x" $(( 0x${MASK_HIGH} << 16 | 0x${MASK_LOW} ))`
            for i in $(seq 0 31); do
                if [ $(( 0x${MASK} & $(( 1 << $i )) )) -eq 0 ]; then
                    BIT_CNT=$i
                fi
            done
            NET_MASK=$(( $IPV4_MASK - ($BIT_CNT + 1) ))
            break;
        fi
    done
    AREA_IDS="${AREA_IDS} $AREA_ID"
    NET_MASKS="${NET_MASKS} $NET_MASK"
done

#echo "AREA_ID is $AREA_IDS"
#echo "NET_MASKS is $NET_MASKS"

for vlan in $VLAN_LIST; do
    echo -e "!\ninterface vlan$vlan" >> $CONN4NET_FILE
    IPADDR=`cat $PKT_FILE | grep "Protocol is 89" -B2 | grep "VLAN Tag: $vlan" -A2 -m1 | awk '/IPSA/{printf "%s" $4}'`
    IP_LAST=${IPADDR:$((${#IPADDR}-1)):$((${#IPADDR}))}
    if [ $(( IP_LAST & 1 )) == 1 ]; then
        MYIP_LAST=`expr $IP_LAST + 1`
    else
        MYIP_LAST=`expr $IP_LAST - 1`
    fi
    echo -e " ip address ${IPADDR:0:$((${#IPADDR}-1))}$MYIP_LAST/$NET_MASK" >> $CONN4NET_FILE
    echo -e " ip ospf mtu-ignore" >> $CONN4NET_FILE
    echo -e " ip ospf network point-to-point" >> $CONN4NET_FILE
done

echo -e "!" >> $CONN4NET_FILE
echo -e "!\nrouter ospf" >> $CONN4NET_FILE
echo -e " router-id 1.1.1.100" >> $CONN4NET_FILE
for vlan in $VLAN_LIST; do
    cnt=$(( cnt+1 ))
    areaID=`echo ${AREA_IDS} | cut -d' ' -f${cnt}`
    IPADDR=`cat $PKT_FILE | grep "Protocol is 89" -B2 | grep "VLAN Tag: $vlan" -A2 -m1 | awk '/IPSA/{printf "%s" $4}'`
    echo -e " network $IPADDR/$NET_MASK area $areaID" >> $CONN4NET_FILE
done

echo -e " network 1.1.1.100/32 area $areaID" >> $CONN4NET_FILE

echo -e "!" >> $CONN4NET_FILE

exec 3<> $CONN4NET_FILE
exec 3>&-

