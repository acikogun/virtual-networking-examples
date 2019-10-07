#!/bin/bash

sudo apt-get update
sudo apt-get install openvswitch-switch openvswitch-vtep -y

sudo ip netns add ns0

sudo ip link add name veth1 type veth peer name sw2-p1
sudo ip link set dev veth1 netns ns0

sudo ip netns exec ns0 ifconfig veth1 10.0.0.20/24 up
sudo ip netns exec ns0 ip link set lo up

sudo ovs-vsctl add-br sw2
sudo ovs-vsctl add-port sw2 sw2-p1
sudo ip link set sw2-p1 up
sudo ip link set sw2 up

sudo ovs-vsctl add-port sw2 vxlan0 -- set interface vxlan0 type=vxlan options:remote_ip=192.168.50.10 options:key=123
