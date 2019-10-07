#!/bin/bash

sudo apt-get update
sudo apt-get install openvswitch-switch openvswitch-vtep -y

sudo ip netns add ns0

sudo ip link add name veth1 type veth peer name sw1-p1
sudo ip link set dev veth1 netns ns0

sudo ip netns exec ns0 ifconfig veth1 10.0.0.10/24 up
sudo ip netns exec ns0 ip link set lo up

sudo ovs-vsctl add-br sw1
sudo ovs-vsctl add-port sw1 sw1-p1
sudo ip link set sw1-p1 up
sudo ip link set sw1 up

sudo ovs-vsctl add-port sw1 vxlan0 -- set interface vxlan0 type=vxlan options:remote_ip=192.168.50.20 options:key=123
