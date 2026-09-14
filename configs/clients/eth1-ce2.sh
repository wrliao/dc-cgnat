#!/bin/bash
for i in {1..10}; do
    ip link show eth1 &>/dev/null && break
    echo "Waiting for eth1..."
    sleep 1
done

# Create VLANs

ip link add link eth1 name eth1.1 type vlan id 1
ip link add link eth1 name eth1.10 type vlan id 10
ip link add link eth1 name eth1.20 type vlan id 20
ip link add link eth1 name eth1.30 type vlan id 30
ip link set dev eth1.1 up
ip link set dev eth1.10 up
ip link set dev eth1.20 up
ip link set dev eth1.30 up

ip addr add 102.0.1.10/24 dev eth1.1
ip addr add 102.1.1.10/24 dev eth1.10
ip addr add 102.2.1.10/24 dev eth1.20
ip addr add 102.11.1.10/24 dev eth1.30
ip r add 103.0.1.0/24 via 102.0.1.1
ip r add 103.1.1.0/24 via 102.1.1.1
ip r add 103.2.1.0/24 via 102.2.1.1
ip r add 103.11.1.0/24 via 102.11.1.1
ip r add 104.0.1.0/24 via 102.0.1.1
ip r add 104.1.1.0/24 via 102.1.1.1
ip r add 104.2.1.0/24 via 102.2.1.1
ip r add 104.11.1.0/24 via 102.11.1.1
