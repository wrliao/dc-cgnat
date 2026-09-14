ip link add link eth1 name eth1.1 type vlan id 1
ip link add link eth1 name eth1.10 type vlan id 10
ip link add link eth1 name eth1.20 type vlan id 20
ip link add link eth1 name eth1.30 type vlan id 30
ip link add link eth1 name eth1.40 type vlan id 40
ip link set dev eth1.1 up
ip link set dev eth1.10 up
ip link set dev eth1.20 up
ip link set dev eth1.30 up
ip link set dev eth1.40 up
