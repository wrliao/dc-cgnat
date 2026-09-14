**Noia SR-OS CGNAT for DC fabric**

<img width="1352" height="996" alt="image" src="https://github.com/user-attachments/assets/a9a85390-3ade-45c7-a2ed-f1d8379b5492" />

In this lab setup, Nokia Srlinux nodes are positioned as DC leaf connected to tenants and Nokia 7750 SR are the Bodrder Leaf as well as supporting per tenant hosts private to public IP address translation using CGNAT capability. 

  * Service-leaf1/2 supports the EVPN type 5 IFL (interface less) over VXLAN (toward DC leaf) and IPVPN stitching services. service-leaf3/4 supports both per tenant VRF and internet VRF for NAT outside pool advertisement toward Internet Peering router.
  * Both stateless (nat-group 1) and stateful (nat-group 2) multl-chassis CGNAT redudancy are enable in service-leaf3 and 4. 

* bngblaster container is used as per tenant host emulation with both icmp and http traffic generation toward internet-host. 
  * tenant1 is running over ip-vrf-tenant1 (service-id 10001 in SROS) from leaf1 to service-leaf 1/2 using EVPN type 5 IFL over VXLAN
  * tenant2 is runnig over ip-vrf-tenant2 (service-id 10002 in SROS) from leaf2 to service-leaf1/2 using EVPN type 5 IFL over VXLAN
  * internet VRF is using service-id 1001 between service-leaf3/4 and internet-peer and running over GRE tunnel using MPLS IPVPN.
 
**Deploying the lab**
``` 
#clone repository
git clone https://github.com/wrliao/dc-cgnat.git
```
``` 
#deploy containerlab topology
clab deploy -t dc-cgnat.clab.yml
``` 
``` 
16:41:24 INFO Containerlab started version=0.79.0
16:41:24 INFO Parsing & checking topology file=dc-cgnat.clab.yml
16:41:24 INFO Creating docker network name=clab IPv4 subnet=172.20.20.0/24 IPv6 subnet=3fff:172:20:20::/64 MTU=0
16:41:24 INFO Creating lab directory path=/home/liao/clab/clab-configs/clab-dc-cgnat/clab-dc-cgnat
16:41:24 INFO Creating container name=internet-host
16:41:24 INFO Creating container name=tenant1
16:41:24 INFO Creating container name=tenant2
16:41:24 INFO Creating container name=tenant3
16:41:24 INFO Creating container name=tenant4
16:41:24 INFO Creating container name=leaf1
16:41:24 INFO Creating container name=leaf2
16:41:25 INFO Retrieved SR OS version from image node=internet-peer version=26.7.1
16:41:25 INFO Creating container name=internet-peer
16:41:25 INFO Retrieved SR OS version from image node=svc-leaf3 version=26.7.1
16:41:25 INFO Creating container name=svc-leaf3
16:41:25 INFO Created link: leaf1:e1-11 ▪┄┄▪ host:clab-s-b43723ba
16:41:25 INFO Created link: leaf2:e1-11 ▪┄┄▪ host:clab-s-17cac4d1
16:41:25 INFO Created link: leaf1:e1-12 ▪┄┄▪ host:clab-s-965bf4fa
16:41:25 INFO Created link: leaf1:e1-1 ▪┄┄▪ tenant1:eth1
16:41:25 INFO Created link: leaf2:e1-12 ▪┄┄▪ host:clab-s-d860cb87
16:41:25 INFO Created link: leaf2:e1-1 ▪┄┄▪ tenant2:eth1
16:41:25 INFO Created link: leaf1:e1-2 ▪┄┄▪ tenant3:eth1
16:41:26 INFO Created link: internet-host:eth1 ▪┄┄▪ host:clab-s-c87fc0e0
16:41:26 INFO Running postdeploy actions kind=nokia_srlinux node=leaf1
16:41:26 INFO Running postdeploy actions kind=nokia_srlinux node=leaf2
16:41:26 INFO Created link: internet-peer:e1-1-c1-1 (1/1/c1/1) ▪┄┄▪ host:clab-s-4250d7a0
16:41:26 INFO Created link: internet-peer:e1-1-c2-1 (1/1/c2/1) ▪┄┄▪ host:clab-s-aaeda20c
16:41:26 INFO Creating container name=gnmic
16:41:26 INFO Created link: internet-peer:e1-1-c3-1 (1/1/c3/1) ▪┄┄▪ host:clab-s-6ed9b91a
16:41:26 INFO Creating container name=prometheus
16:41:26 INFO Running postdeploy actions kind=nokia_srsim node=internet-peer
16:41:26 INFO Created link: leaf2:e1-2 ▪┄┄▪ tenant4:eth1
16:41:26 INFO Running postdeploy actions kind=nokia_srsim node=svc-leaf3
16:41:26 INFO Retrieved SR OS version from image node=svc-leaf4 version=26.7.1
16:41:26 INFO Creating container name=svc-leaf4
16:41:26 INFO Creating container name=grafana
16:41:26 INFO Retrieved SR OS version from image node=svc-leaf2 version=26.7.1
16:41:26 INFO Creating container name=svc-leaf2
16:41:26 INFO Retrieved SR OS version from image node=svc-leaf1 version=26.7.1
16:41:26 INFO Creating container name=svc-leaf1
16:41:27 INFO Creating container name=tenant5
16:41:27 INFO Running postdeploy actions kind=nokia_srsim node=svc-leaf4
16:41:27 INFO Creating container name=svc-leaf3-iom1
16:41:27 INFO Created link: svc-leaf2:e1-1-c1-1 (1/1/c1/1) ▪┄┄▪ host:clab-s-34de1f96
16:41:28 INFO Created link: svc-leaf2:e1-1-c2-1 (1/1/c2/1) ▪┄┄▪ host:clab-s-248b40f4
16:41:28 INFO Created link: svc-leaf2:e1-1-c3-1 (1/1/c3/1) ▪┄┄▪ host:clab-s-b9e4c925
16:41:28 INFO Created link: svc-leaf1:e1-1-c1-1 (1/1/c1/1) ▪┄┄▪ host:clab-s-6e41364e
16:41:28 INFO Created link: svc-leaf2:e1-1-c4-1 (1/1/c4/1) ▪┄┄▪ host:clab-s-83ccf88a
16:41:28 INFO Created link: svc-leaf3-iom1:e1-1-1 (1/1/1) ▪┄┄▪ host:clab-s-9f6f3540
16:41:28 INFO Created link: svc-leaf2:e1-1-c11-1 (1/1/c11/1) ▪┄┄▪ host:clab-s-50a79ec6
16:41:28 INFO Created link: svc-leaf3-iom1:e1-1-2 (1/1/2) ▪┄┄▪ host:clab-s-13d14a69
16:41:28 INFO Running postdeploy actions kind=nokia_srsim node=svc-leaf3-iom1
16:41:28 INFO Created link: svc-leaf1:e1-1-c2-1 (1/1/c2/1) ▪┄┄▪ host:clab-s-ad59c81b
16:41:28 INFO Created link: svc-leaf2:e1-1-c12-1 (1/1/c12/1) ▪┄┄▪ host:clab-s-8502ab66
16:41:28 INFO Running postdeploy actions kind=nokia_srsim node=svc-leaf2
16:41:28 INFO Created link: svc-leaf1:e1-1-c3-1 (1/1/c3/1) ▪┄┄▪ host:clab-s-4c8c078f
16:41:28 INFO Created link: svc-leaf1:e1-1-c4-1 (1/1/c4/1) ▪┄┄▪ host:clab-s-eaf7bf8e
16:41:28 INFO Created link: svc-leaf1:e1-1-c11-1 (1/1/c11/1) ▪┄┄▪ host:clab-s-e30265b9
16:41:28 INFO Created link: svc-leaf1:e1-1-c12-1 (1/1/c12/1) ▪┄┄▪ host:clab-s-1df71dca
16:41:28 INFO Running postdeploy actions kind=nokia_srsim node=svc-leaf1
16:41:28 INFO Created link: leaf1:e1-3 ▪┄┄▪ tenant5:eth1
16:41:28 INFO Created link: leaf2:e1-3 ▪┄┄▪ tenant5:eth2
16:41:28 INFO Creating container name=svc-leaf4-iom1
16:41:29 INFO Created link: svc-leaf4-iom1:e1-1-1 (1/1/1) ▪┄┄▪ host:clab-s-c54147ad
16:41:29 INFO Created link: svc-leaf4-iom1:e1-1-2 (1/1/2) ▪┄┄▪ host:clab-s-1dabafdc
16:41:29 INFO Running postdeploy actions kind=nokia_srsim node=svc-leaf4-iom1
16:41:43 INFO Executed command node=tenant1 command="bash /config/eth1.sh" stdout=""
16:41:43 INFO Executed command node=tenant1 command="ip addr add 10.0.10.10/24 dev eth1.10" stdout=""
16:41:43 INFO Executed command node=tenant3 command="bash /config/eth1.sh" stdout=""
16:41:43 INFO Executed command node=tenant2 command="bash /config/eth1.sh" stdout=""
16:41:43 INFO Executed command node=internet-host command="bash /config/eth1.sh" stdout=""
16:41:43 INFO Executed command node=tenant2 command="ip addr add 10.0.10.10/24 dev eth1.20" stdout=""
16:41:43 INFO Executed command node=tenant3 command="ip addr add 10.0.10.10/24 dev eth1.30" stdout=""
16:41:43 INFO Executed command node=tenant1 command="ip r add 11.0.0.0/8 via 10.0.10.1" stdout=""
16:41:43 INFO Executed command node=tenant2 command="ip r add 11.0.0.0/8 via 10.0.10.1" stdout=""
16:41:43 INFO Executed command node=internet-host command="ip addr add 11.0.10.10/24 dev eth1.10" stdout=""
16:41:43 INFO Executed command node=tenant3 command="ip r add 11.0.0.0/8 via 10.0.10.1" stdout=""
16:41:43 INFO Executed command node=internet-host command="ip r add 11.0.0.0/8 via 11.0.10.1" stdout=""
16:41:43 INFO Executed command node=internet-host command="ip r add 21.0.0.0/8 via 11.0.10.1" stdout=""
16:41:43 INFO Executed command node=tenant4 command="bash /config/eth1.sh" stdout=""
16:41:43 INFO Executed command node=tenant4 command="ip addr add 10.0.10.10/24 dev eth1.40" stdout=""
16:41:43 INFO Executed command node=internet-host command="ip r add 2.0.0.0/8 via 11.0.10.1" stdout=""
16:41:43 INFO Executed command node=tenant4 command="ip r add 11.0.0.0/8 via 10.0.10.1" stdout=""
16:41:43 INFO Executed command node=tenant5 command="bash /config/eth1.sh" stdout=""
16:41:43 INFO Executed command node=tenant5 command="ip addr add 10.0.10.10/24 dev eth1.50" stdout=""
16:41:43 INFO Executed command node=tenant5 command="ip r add 11.0.0.0/8 via 10.0.10.1" stdout=""
16:41:43 INFO Adding host entries path=/etc/hosts
16:41:43 INFO Adding SSH config for nodes path=/etc/ssh/ssh_config.d/clab-dc-cgnat.conf
╭──────────────────────────────┬────────────────────────────────────────────┬─────────┬────────────────────╮
│             Name             │                 Kind/Image                 │  State  │   IPv4/6 Address   │
├──────────────────────────────┼────────────────────────────────────────────┼─────────┼────────────────────┤
│ clab-dc-cgnat-gnmic          │ linux                                      │ running │ 172.20.20.11       │
│                              │ ghcr.io/openconfig/gnmic:0.39.1            │         │ 3fff:172:20:20::b  │
├──────────────────────────────┼────────────────────────────────────────────┼─────────┼────────────────────┤
│ clab-dc-cgnat-grafana        │ linux                                      │ running │ 172.20.20.14       │
│                              │ grafana/grafana:11.6.3                     │         │ 3fff:172:20:20::e  │
├──────────────────────────────┼────────────────────────────────────────────┼─────────┼────────────────────┤
│ clab-dc-cgnat-internet-host  │ linux                                      │ running │ 172.20.20.7        │
│                              │ ghcr.io/srl-labs/network-multitool:v0.10.0 │         │ 3fff:172:20:20::7  │
├──────────────────────────────┼────────────────────────────────────────────┼─────────┼────────────────────┤
│ clab-dc-cgnat-internet-peer  │ nokia_srsim                                │ running │ 172.20.20.8        │
│                              │ nokia_srsim:26.7.R1                        │         │ 3fff:172:20:20::8  │
├──────────────────────────────┼────────────────────────────────────────────┼─────────┼────────────────────┤
│ clab-dc-cgnat-leaf1          │ nokia_srlinux                              │ running │ 172.20.20.2        │
│                              │ ghcr.io/nokia/srlinux:26.7.1               │         │ 3fff:172:20:20::2  │
├──────────────────────────────┼────────────────────────────────────────────┼─────────┼────────────────────┤
│ clab-dc-cgnat-leaf2          │ nokia_srlinux                              │ running │ 172.20.20.3        │
│                              │ ghcr.io/nokia/srlinux:26.7.1               │         │ 3fff:172:20:20::3  │
├──────────────────────────────┼────────────────────────────────────────────┼─────────┼────────────────────┤
│ clab-dc-cgnat-prometheus     │ linux                                      │ running │ 172.20.20.12       │
│                              │ prom/prometheus:v2.54.1                    │         │ 3fff:172:20:20::c  │
├──────────────────────────────┼────────────────────────────────────────────┼─────────┼────────────────────┤
│ clab-dc-cgnat-svc-leaf1      │ nokia_srsim                                │ running │ 172.20.20.16       │
│                              │ nokia_srsim:26.7.R1                        │         │ 3fff:172:20:20::10 │
├──────────────────────────────┼────────────────────────────────────────────┼─────────┼────────────────────┤
│ clab-dc-cgnat-svc-leaf2      │ nokia_srsim                                │ running │ 172.20.20.15       │
│                              │ nokia_srsim:26.7.R1                        │         │ 3fff:172:20:20::f  │
├──────────────────────────────┼────────────────────────────────────────────┼─────────┼────────────────────┤
│ clab-dc-cgnat-svc-leaf3      │ nokia_srsim                                │ running │ 172.20.20.10       │
│                              │ nokia_srsim:26.7.R1                        │         │ 3fff:172:20:20::a  │
├──────────────────────────────┼────────────────────────────────────────────┼─────────┼────────────────────┤
│ clab-dc-cgnat-svc-leaf3-iom1 │ nokia_srsim                                │ running │ N/A                │
│                              │ nokia_srsim:26.7.R1                        │         │ N/A                │
├──────────────────────────────┼────────────────────────────────────────────┼─────────┼────────────────────┤
│ clab-dc-cgnat-svc-leaf4      │ nokia_srsim                                │ running │ 172.20.20.13       │
│                              │ nokia_srsim:26.7.R1                        │         │ 3fff:172:20:20::d  │
├──────────────────────────────┼────────────────────────────────────────────┼─────────┼────────────────────┤
│ clab-dc-cgnat-svc-leaf4-iom1 │ nokia_srsim                                │ running │ N/A                │
│                              │ nokia_srsim:26.7.R1                        │         │ N/A                │
├──────────────────────────────┼────────────────────────────────────────────┼─────────┼────────────────────┤
│ clab-dc-cgnat-tenant1        │ linux                                      │ running │ 172.20.20.5        │
│                              │ ghcr.io/srl-labs/network-multitool:v0.10.0 │         │ 3fff:172:20:20::5  │
├──────────────────────────────┼────────────────────────────────────────────┼─────────┼────────────────────┤
│ clab-dc-cgnat-tenant2        │ linux                                      │ running │ 172.20.20.4        │
│                              │ ghcr.io/srl-labs/network-multitool:v0.10.0 │         │ 3fff:172:20:20::4  │
├──────────────────────────────┼────────────────────────────────────────────┼─────────┼────────────────────┤
│ clab-dc-cgnat-tenant3        │ linux                                      │ running │ 172.20.20.6        │
│                              │ ghcr.io/srl-labs/network-multitool:v0.10.0 │         │ 3fff:172:20:20::6  │
├──────────────────────────────┼────────────────────────────────────────────┼─────────┼────────────────────┤
│ clab-dc-cgnat-tenant4        │ linux                                      │ running │ 172.20.20.9        │
│                              │ ghcr.io/srl-labs/network-multitool:v0.10.0 │         │ 3fff:172:20:20::9  │
├──────────────────────────────┼────────────────────────────────────────────┼─────────┼────────────────────┤
│ clab-dc-cgnat-tenant5        │ linux                                      │ running │ 172.20.20.17       │
│                              │ ghcr.io/srl-labs/network-multitool:v0.10.0 │         │ 3fff:172:20:20::11 │
╰──────────────────────────────┴────────────────────────────────────────────┴─────────┴────────────────────╯
``` 

**CGNAT Lab information**

* tenant1 ip-vrf EVPN type 5 IFL over VXLAN in leaf1

``` 
A:admin@leaf1# show network-instance ip-vrf-tenant-1 ipv4 route
======================================================================================================
IPv4-unicast route table for ip-vrf network-instance: ip-vrf-tenant-1
------------------------------------------------------------------------------------------------------
Flags: > (best), * (unviable), ! (failed)
     : L (leaked route from another network-instance)
     : B (backup NHG active and displayed)
     : S (statistics supported)
     : D (dynamic LB), R (resilient LB)
------------------------------------------------------------------------------------------------------
Prefix               Route Type   Metric   Pref    Flags    Next-Hop(s)
------------------------------------------------------------------------------------------------------
0.0.0.0/0            bgp-evpn     0        170     >        2.2.2.1(tunnel:vxlan, vni:10)
10.0.10.0/24         local        0        0       >        10.0.10.1(ethernet-1/1.10)
11.251.2.3/32        bgp-evpn     0        170     >        2.2.2.1(tunnel:vxlan, vni:10)
11.254.2.1/32        bgp-evpn     0        170     >        2.2.2.1(tunnel:vxlan, vni:10)
11.254.2.2/32        bgp-evpn     0        170     >        2.2.2.2(tunnel:vxlan, vni:10)
11.254.2.3/32        bgp-evpn     0        170     >        2.2.2.1(tunnel:vxlan, vni:10)
11.254.2.4/32        bgp-evpn     0        170     >        2.2.2.1(tunnel:vxlan, vni:10)
```

* tenant1 ip-vrf EVPN type 5 IFL over VXLAN and IPVPN stitching (Service Leaf1)

```
A:admin@svc-leaf1# show router 10001 route-table 

===============================================================================
Route Table (Service: 10001)
===============================================================================
Dest Prefix[Flags]                            Type    Proto     Age        Pref
      Next Hop[Interface Name]                                    Metric   
-------------------------------------------------------------------------------
0.0.0.0/0                                     Remote  BGP VPN   00h22m53s  170
       2.2.2.3 (tunneled)                                           10
10.0.10.0/24                                  Remote  EVPN-IFL  00h24m32s  170
       1.1.1.1 (tunneled:VXLAN:10)                                  0
11.251.2.3/32                                 Remote  BGP VPN   00h22m53s  170
       2.2.2.3 (tunneled)                                           10
11.254.2.1/32                                 Local   Local     00h26m03s  0
       loopback                                                     0
11.254.2.2/32                                 Remote  EVPN-IFL  00h25m03s  170
       2.2.2.2 (tunneled:VXLAN:10)                                  10
11.254.2.3/32                                 Remote  BGP VPN   00h25m01s  170
       2.2.2.3 (tunneled)                                           10
11.254.2.4/32                                 Remote  BGP VPN   00h25m03s  170
       2.2.2.4 (tunneled)                                           20
-------------------------------------------------------------------------------
No. of Routes: 7
```

* tenant1 ip-vrf and divert traffic to CGNAT (Service Leaf3)
```
A:admin@svc-leaf3# show router 10001 route-table 

===============================================================================
Route Table (Service: 10001)
===============================================================================
Dest Prefix[Flags]                            Type    Proto     Age        Pref
      Next Hop[Interface Name]                                    Metric   
-------------------------------------------------------------------------------
0.0.0.0/0                                     Remote  NAT       00h26m01s  0
       NAT inside                                                   0
10.0.10.0/24                                  Remote  BGP VPN   00h27m41s  170
       2.2.2.1 (tunneled)                                           10
11.251.2.3/32                                 Remote  NAT       00h26m01s  0
       Black Hole                                                   0
11.254.2.1/32                                 Remote  BGP VPN   00h28m10s  170
       2.2.2.1 (tunneled)                                           10
11.254.2.2/32                                 Remote  BGP VPN   00h28m10s  170
       2.2.2.2 (tunneled)                                           20
11.254.2.3/32                                 Local   Local     00h29m06s  0
       loopback                                                     0
11.254.2.4/32                                 Remote  BGP VPN   00h28m10s  170
       2.2.2.4 (tunneled)                                           30
-------------------------------------------------------------------------------
No. of Routes: 7
Flags: n = Number of times nexthop is repeated
       B = BGP backup route available
       L = LFA nexthop available
       S = Sticky ECMP requested
===============================================================================
```
internet-vrf (service-id 1001) and nat outside pool
```
A:admin@svc-leaf3# show router 1001 route-table  

===============================================================================
Route Table (Service: 1001)
===============================================================================
Dest Prefix[Flags]                            Type    Proto     Age        Pref
      Next Hop[Interface Name]                                    Metric   
-------------------------------------------------------------------------------
2.2.2.3/32                                    Local   Local     00h30m40s  0
       loopback                                                     0
2.2.2.4/32                                    Remote  BGP VPN   00h29m44s  170
       2.2.2.4 (tunneled)                                           30
2.2.2.5/32                                    Remote  BGP VPN   00h29m43s  170
       2.2.2.5 (tunneled)                                           20
11.0.10.0/24                                  Remote  BGP VPN   00h29m43s  170
       2.2.2.5 (tunneled)                                           20
11.0.20.0/24                                  Remote  BGP VPN   00h29m43s  170
       2.2.2.5 (tunneled)                                           20
11.1.0.0/24                                   Blackh* Aggr      00h27m35s  130
       Black Hole                                                   0
11.1.0.1/32                                   Remote  NAT       00h27m35s  0
       NAT outside to mda 1/3                                       0
11.1.0.2/31                                   Remote  NAT       00h27m35s  0
       NAT outside to mda 1/3                                       0
11.1.0.4/30                                   Remote  NAT       00h27m35s  0
       NAT outside to mda 1/3                                       0
11.1.0.8/29                                   Remote  NAT       00h27m35s  0
       NAT outside to mda 1/3                                       0
11.1.0.16/28                                  Remote  NAT       00h27m35s  0
       NAT outside to mda 1/3                                       0
11.1.0.32/27                                  Remote  NAT       00h27m35s  0
       NAT outside to mda 1/3                                       0
11.1.0.64/26                                  Remote  NAT       00h27m35s  0
       NAT outside to mda 1/3                                       0
11.1.0.128/26                                 Remote  NAT       00h27m35s  0
       NAT outside to mda 1/2                                       0
11.1.0.192/27                                 Remote  NAT       00h27m35s  0
       NAT outside to mda 1/2                                       0
11.1.0.224/28                                 Remote  NAT       00h27m35s  0
       NAT outside to mda 1/2                                       0
11.1.0.240/29                                 Remote  NAT       00h27m35s  0
       NAT outside to mda 1/2                                       0
11.1.0.248/30                                 Remote  NAT       00h27m35s  0
       NAT outside to mda 1/2                                       0
11.1.0.252/31                                 Remote  NAT       00h27m35s  0
       NAT outside to mda 1/2                                       0
11.1.0.254/32                                 Remote  NAT       00h27m35s  0
       NAT outside to mda 1/2                                       0
11.2.0.0/24                                   Blackh* Aggr      00h29m44s  130
       Black Hole                                                   0
11.2.0.1/32                                   Remote  BGP VPN   00h29m44s  170
       2.2.2.4 (tunneled)                                           30
11.2.0.2/31                                   Remote  BGP VPN   00h29m44s  170
       2.2.2.4 (tunneled)                                           30
11.2.0.4/30                                   Remote  BGP VPN   00h29m44s  170
       2.2.2.4 (tunneled)                                           30
11.2.0.8/29                                   Remote  BGP VPN   00h29m44s  170
       2.2.2.4 (tunneled)                                           30
11.2.0.16/28                                  Remote  BGP VPN   00h29m44s  170
       2.2.2.4 (tunneled)                                           30
11.2.0.32/27                                  Remote  BGP VPN   00h29m44s  170
       2.2.2.4 (tunneled)                                           30
11.2.0.64/26                                  Remote  BGP VPN   00h29m44s  170
       2.2.2.4 (tunneled)                                           30
11.2.0.128/26                                 Remote  BGP VPN   00h29m44s  170
       2.2.2.4 (tunneled)                                           30
11.2.0.192/27                                 Remote  BGP VPN   00h29m44s  170
       2.2.2.4 (tunneled)                                           30
11.2.0.224/28                                 Remote  BGP VPN   00h29m44s  170
       2.2.2.4 (tunneled)                                           30
11.2.0.240/29                                 Remote  BGP VPN   00h29m44s  170
       2.2.2.4 (tunneled)                                           30
11.2.0.248/30                                 Remote  BGP VPN   00h29m44s  170
       2.2.2.4 (tunneled)                                           30
11.2.0.252/31                                 Remote  BGP VPN   00h29m44s  170
       2.2.2.4 (tunneled)                                           30
11.2.0.254/32                                 Remote  BGP VPN   00h29m44s  170
       2.2.2.4 (tunneled)                                           30
11.3.0.1/32                                   Remote  NAT       00h27m35s  0
       NAT outside to mda 1/3                                       0
11.3.0.2/31                                   Remote  NAT       00h27m35s  0
       NAT outside to mda 1/3                                       0
11.3.0.4/30                                   Remote  NAT       00h27m35s  0
       NAT outside to mda 1/3                                       0
11.3.0.8/29                                   Remote  NAT       00h27m35s  0
       NAT outside to mda 1/3                                       0
11.3.0.16/28                                  Remote  NAT       00h27m35s  0
       NAT outside to mda 1/3                                       0
11.3.0.32/27                                  Remote  NAT       00h27m35s  0
       NAT outside to mda 1/3                                       0
11.3.0.64/26                                  Remote  NAT       00h27m35s  0
       NAT outside to mda 1/3                                       0
11.3.0.128/26                                 Remote  NAT       00h27m35s  0
       NAT outside to mda 1/2                                       0
11.3.0.192/27                                 Remote  NAT       00h27m35s  0
       NAT outside to mda 1/2                                       0
11.3.0.224/28                                 Remote  NAT       00h27m35s  0
       NAT outside to mda 1/2                                       0
11.3.0.240/29                                 Remote  NAT       00h27m35s  0
       NAT outside to mda 1/2                                       0
11.3.0.248/30                                 Remote  NAT       00h27m35s  0
       NAT outside to mda 1/2                                       0
11.3.0.252/31                                 Remote  NAT       00h27m35s  0
       NAT outside to mda 1/2                                       0
11.3.0.254/32                                 Remote  NAT       00h27m35s  0
       NAT outside to mda 1/2                                       0
11.250.3.1/32                                 Remote  NAT       00h30m35s  0
       NAT inter-chassis to mda 1/4                                 0
11.250.4.1/32                                 Remote  BGP VPN   00h29m44s  170
       2.2.2.4 (tunneled)                                           30
11.251.2.3/32                                 Remote  NAT       00h27m35s  0
       Black Hole                                                   0
11.252.2.4/32                                 Remote  NAT       00h27m35s  0
       Black Hole                                                   0
-------------------------------------------------------------------------------
No. of Routes: 53
Flags: n = Number of times nexthop is repeated
       B = BGP backup route available
       L = LFA nexthop available
       S = Sticky ECMP requested
===============================================================================
* indicates that the corresponding row element may have been truncated.
```

* stateless multichassis for nat-group 1 pool-a
```
A:admin@svc-leaf3# show router 1001 nat pool "pool-a" 

===============================================================================
NAT Pool pool-a
===============================================================================
Description                           : (Not Specified)
ISA NAT Group                         : 1
Pool type                             : largeScale
Address pooling                       : paired
Applications                          : (None)
Admin state                           : inService
Mode                                  : napt
Port forwarding dyn blocks reserved   : 0
Port forwarding range                 : 1 - 1023
Port reservation                      : 128 blocks
Block usage High Watermark (%)        : (Not Specified)
Block usage Low Watermark (%)         : (Not Specified)
ICMP echo reply                       : disabled
Monitor Operational Group             : N/A
Subscriber limit per IP address       : N/A
Active                                : true
Deterministic port reservation        : (Not Specified)
Last Mgmt Change                      : 09/14/2026 05:27:35
===============================================================================

===============================================================================
NAT address ranges of pool pool-a
===============================================================================
Range                                               Drain Num-blk    
-------------------------------------------------------------------------------
11.1.0.1 - 11.1.0.254                                     0          
-------------------------------------------------------------------------------
No. of ranges: 1
===============================================================================

===============================================================================
NAT members of pool pool-a ISA NAT group 1
===============================================================================
Member                                                        Block-Usage-% Hi
-------------------------------------------------------------------------------
1                                                             < 1           N
2                                                             < 1           N
-------------------------------------------------------------------------------
No. of members: 2
===============================================================================

===============================================================================
Dual-Homing
===============================================================================
Type                                  : Leader
Export route                          : 11.251.2.3/32
Monitor route                         : 11.251.2.4/32
Admin state                           : inService
Dual-Homing State                     : Active
===============================================================================

=========================================================================
Dual-Homing fate-share-group
=========================================================================
Router         Pool                                  Type      State
-------------------------------------------------------------------------
vprn1001       pool-a                                Leader    Active
-------------------------------------------------------------------------
No. of pools: 1
=========================================================================
```


* stateless multichassis for nat-group 1 pool-a
```
A:admin@svc-leaf4# show isa nat-group 2 inter-chassis-redundancy member 1

===============================================================================
NAT inter-chassis redundancy member state
===============================================================================
State                       : active
Peer state                  : standby
Local IP address            : 11.250.4.1
Remote IP address           : 11.250.3.1
Unsupported flows           : 0
Tracked flows               : 0
Tracked flows not synced    : 0
Tracked flows pending       : 0
Flows synced                : 0
Flows marked to delete      : 0
Flows delete pending        : 0
Time of last failure        : N/A
Failure cause               : N/A
===============================================================================
```

generate traffic flows from tenant side

```
 ./run_traffic.sh 
========================================
 Interactive Mode
========================================
Enter Containerlab Project Name [default: clab-dc-cgnat]: 
Enter Tenant Name (e.g., tenant1, tenant2): tenant2
Enter Number of Hosts per Tenant (e.g., 250): 250
Enter Traffic Type (icmp or http): icmp
```
```
F1: Select View  F7/F8: Start/Stop Traffic  F9: Terminate Sessions                        Sep 14 06:32:21.538790 Warning: Interfaces must not have an IP address
Left/Right: Access Interface                                                               configured in the host OS!
                                                                                          Sep 14 06:32:21.538792 Warning: IP address fe80::a8c1:abff:fe29:653f o
      ____   __   ____         _        __                                  ,/            n interface eth1 is conflicting!
     / __ \ / /_ / __ ) _____ (_)_____ / /__                              ,'/             Sep 14 06:32:21.548335 Total PPS of all streams: 0.00
    / /_/ // __// __  |/ ___// // ___// //_/                            ,' /              Sep 14 06:32:21.650284 Resolve network interfaces
   / _, _// /_ / /_/ // /   / // /__ / ,<                             ,'  /_____,         Sep 14 06:32:21.650347 All network interfaces resolved
  /_/ |_| \__//_____//_/   /_/ \___//_/|_|                          .'____    ,'          Sep 14 06:32:22.262529 ALL SESSIONS ESTABLISHED
      ____   _   _  ______   ____   _               _                    /  ,'
     / __ ) / | / // ____/  / __ ) / /____ _ _____ / /_ ___   ____      / ,'
    / __  |/  |/ // / __   / __  |/ // __ `// ___// __// _ \ / ___/    /,'
   / /_/ // /|  // /_/ /  / /_/ // // /_/ /(__  )/ /_ /  __// /       /
  /_____//_/ |_/ \____/  /_____//_/ \__,_//____/ \__/ \___//_/

Test Duration: 6s All Sessions Established: 5s

Sessions             250 (0 PPPoE / 250 IPoE)
  Established        250 [############################################################]
  Outstanding          0 [                                                            ]
  Terminated           0 [                                                            ]
  Setup Time         613 ms
  Setup Rate      407.83 CPS (MIN: 407.83 AVG: 1884.55 MAX: 10000.00)
  Flapped              0

Access Interface ( eth1 )
  TX Packets                      1589 |    242 PPS        100 Kbps 0.000 Gbps
  RX Packets                      1554 |    236 PPS        105 Kbps 0.000 Gbps
  RX Multicast Packets               0 |      0 PPS          0 Loss


```
