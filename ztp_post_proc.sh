#!/bin/sh

echo "ZTP post procedure ......"

ovs-ofctl add-flow br0 priority=65000,tun_id=88,in_port=2201,actions=mod_vlan_vid:88,output:1
ovs-ofctl add-flow br0 priority=65000,tun_id=104,in_port=2201,actions=mod_vlan_vid:104,output:1
ovs-ofctl add-flow br0 priority=65000,in_port=1,dl_vlan=88,actions=set_tunnel:88,output:2201
ovs-ofctl add-flow br0 priority=65000,in_port=1,dl_vlan=104,actions=set_tunnel:104,output:2201

