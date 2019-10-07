#!/bin/bash

cp /vagrant/ifcfg-tun0-host2 /etc/sysconfig/network-scripts/ifcfg-tun0

ifup tun0
