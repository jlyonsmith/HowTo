#!/bin/bash

echo "
################################################################################
#              BPT / Naviserver - Custom CentOS Network Settings               #
################################################################################

net.ipv4.tcp_sack = 1
net.ipv4.tcp_timestamps = 1
net.ipv4.tcp_wmem = 4096 65536 4194304
net.ipv4.tcp_rmem = 4096 87380 4194304

net.ipv4.tcp_fin_timeout = 1
net.ipv4.tcp_tw_recycle = 1
net.core.wmem_max = 16777216
net.core.rmem_max = 16777216
net.core.wmem_default = 16777216
net.core.rmem_default = 16777216
net.core.netdev_max_backlog = 262144
net.core.somaxconn = 262144

net.ipv4.tcp_syncookies = 0
net.ipv4.tcp_max_orphans = 262144
net.ipv4.tcp_max_syn_backlog = 262144
net.ipv4.tcp_synack_retries = 2
net.ipv4.tcp_syn_retries = 2

net.ipv4.tcp_syncookies = 0

net.ipv4.tcp_tw_reuse = 0
net.ipv4.tcp_tw_recycle = 0

net.ipv4.tcp_fastopen = 1

vm.swappiness = 10

################################################################################
" > /etc/sysctl.d/85-BPT-Network.conf

echo "
################################################################################
#              BPT / Naviserver - Custom CentOS Data I/O Settings              #
################################################################################

aolserv       soft           nofile         65535
aolserv       hard           nofile         65535

aolserv       soft           nproc          65535
aolserv       hard           nproc          65535

################################################################################
" > /etc/security/limits.d/85-BPT-Limits.conf

useradd aolserv
mkdir /home/aolserv/source
mkdir /httpd
mkdir /httpd/components
chown aolserv.aolserv -R /httpd
shutdown -r now
