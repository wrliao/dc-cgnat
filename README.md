**Noia SR-OS CGNAT for DC fabric**

<img width="1352" height="996" alt="image" src="https://github.com/user-attachments/assets/a9a85390-3ade-45c7-a2ed-f1d8379b5492" />

In this lab setup, Nokia Srlinux nodes are positioned as DC leaf and Nokia 7750 SR as Bodrder Leaf as well as supporting per tenant hosts private to public IP address translation using CGNAT capability. 

Service-leaf1/2 supports the EVPN type 5 IFL (interface less) over VXLAN (toward DC leaf) and IPVPN stitching services. service-leaf3/4 supports both per tenant VRF and internet VRF for NAT outside pool advertisement toward Internet Peering router.

Both stateless (nat-group 1) and stateful (nat-group 2) multl-chassis CGNAT redudancy are enable in service-leaf3 and 4. 

bngblaster container is used as per tenant host emulation with both icmp and http traffic generation toward internet-host. 

tenant1 is running over ip-vrf-tenant1 (service-id 10001 in SROS) from leaf1 to service-leaf 1/2 using EVPN type 5 IFL over VXLAN
tenant2 is runnig over ip-vrf-tenant2 (service-id 10002 in SROS) from leaf2 to service-leaf1/2 using EVPN type 5 IFL over VXLAN
internet VRF is using service-id 1001 between service-leaf3/4 and internet-peer and running over GRE tunnel using MPLS IPVPN.
