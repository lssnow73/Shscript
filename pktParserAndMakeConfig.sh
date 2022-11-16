#!/bin/sh

VLAN_LIST=`cat /mnt/flash/mirror/* | grep -i -B2 "Protocol is 89" | awk '/VLAN/{ sub(",", "", $3); vlans[$3]++ } END { for (vlan in vlans) {printf("%s ", vlan) }}'`

# IPADDR have IP address.
for vlan in $VLAN_LIST; do
    IPADDR=`cat /mnt/flash/mirror/* | grep "Protocol is 89" -B2 | grep "VLAN Tag: $vlan" -A2 -m 1 | awk '/IPSA/{print $4}'`
    echo "IP address is $IPADDR"
done


# Remove last character. aka space
echo "VLAN list is #${VLAN_LIST:0:$((${#VLAN_LIST}-1))}#"
VLAN_RANGE=${VLAN_LIST:0:$((${#VLAN_LIST}-1))}

echo "vlan range ${VLAN_RANGE// /,}"
echo -e "!\nvlan range ${VLAN_RANGE// /,}\n!" > conn4net.conf

echo -e "!\ninterface eth-0-1" >> conn4net.conf
echo -e " switchport mode trunk" >> conn4net.conf

for vlan in $VLAN_LIST; do
    echo -e " switchport trunk allowed vlan add $vlan" >> conn4net.conf
done

echo -e " openflow enable" >> conn4net.conf
echo -e " vlan-filter disable" >> conn4net.conf
echo -e " no openflow tunnel-mpls enable" >> conn4net.conf


for vlan in $VLAN_LIST; do
    echo -e "!\ninterface vlan$vlan" >> conn4net.conf
    IPADDR=`cat /mnt/flash/mirror/* | grep "Protocol is 89" -B2 | grep "VLAN Tag: $vlan" -A2 -m1 | awk '/IPSA/{printf "%s" $4}'`
    echo -e " ip address ${IPADDR:0:$((${#IPADDR}-1))}`expr ${IPADDR:$((${#IPADDR}-1)):$((${#IPADDR}))} + 1`/30" >> conn4net.conf
    echo -e " ip ospf network point-to-point"
done

echo -e "!" >> conn4net.conf
echo -e "!\nrouter ospf" >> conn4net.conf
echo -e " router-id 1.1.1.100" >> conn4net.conf
for vlan in $VLAN_LIST; do
    IPADDR=`cat /mnt/flash/mirror/* | grep "Protocol is 89" -B2 | grep "VLAN Tag: $vlan" -A2 -m1 | awk '/IPSA/{printf "%s" $4}'`
    echo -e " network $IPADDR/30 area 1" >> conn4net.conf
done

echo -e " network 1.1.1.100/32 area 1" >> conn4net.conf

echo -e "!" >> conn4net.conf
