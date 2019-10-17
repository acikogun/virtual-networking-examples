#!/bin/bash

sudo apt update
sudo apt-get install bridge-utils net-tools -y

sudo ip netns add overns

sudo ip netns exec overns ip link add dev br0 type bridge
sudo ip netns exec overns ip addr add dev br0 10.0.0.1/24
sudo ip netns exec overns ip link set br0 up

sudo ip link add dev vxlan1 type vxlan id 42 proxy learning dstport 4789
sudo ip link set vxlan1 netns overns
sudo ip netns exec overns ip link set vxlan1 master br0
sudo ip netns exec overns ip link set vxlan1 up

sudo ip link add dev veth1 mtu 1450 type veth peer name veth2 mtu 1450
sudo ip link set dev veth1 netns overns
sudo ip netns exec overns ip link set veth1 master br0
sudo ip netns exec overns ip link set veth1 up

sudo ip netns add c1
sudo ip link set dev veth2 netns c1
sudo ip netns exec c1 ip link set dev veth2 name eth0 address 02:42:c0:a8:00:10
sudo ip netns exec c1 ip addr add dev eth0 10.0.0.10/24
sudo ip netns exec c1 ip link set dev eth0 up

sudo ip netns exec overns ip neighbor add 10.0.0.20 lladdr 02:42:c0:a8:00:20 dev vxlan1
sudo ip netns exec overns bridge fdb add 02:42:c0:a8:00:20 dev vxlan1 self dst 192.168.50.20 vni 42 port 4789
