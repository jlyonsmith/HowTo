#!/bin/bash

#########################################
#########################################
##                                     ##
## BPT | Naviserver Installation Steps ##
##                                     ##
#########################################
#########################################
#
# Install CentOS 7.x with the following settings:
#
#       * Software Selection:
#               Minimal Install
#       * Directory Structure:
#               Swap                    16GB        (Standard Partition)
#               /boot                   2048MB  XFS (Standard Partition)
#               /                       100GB   XFS (Standard Partition)
#       * Kdump:
#               Disabled
#       * Security Policy:
#               None
#
#########################################

###############
# Prep CentOS #
###############

yum -y update
yum -y install epel-release
yum -y install iptables-services sendmail ntp ntpdate \
        iotop net-tools sysstat \
        git wget unzip \
        autoconf automake gcc m4 make \
        jemalloc jemalloc-devel \
        openssl-devel

systemctl stop NetworkManager
systemctl disable NetworkManager
systemctl start network
systemctl enable network
systemctl start ntpd
systemctl enable ntpd
systemctl start sendmail
systemctl enable sendmail
echo "root:          admin@brownpapertickets.com" >> /etc/aliases
newaliases
systemctl stop firewalld
systemctl disable firewalld
systemctl start iptables
systemctl enable iptables
mv /etc/sysconfig/iptables /etc/sysconfig/iptables.original
echo "
################################################################################
#               BPT / Naviserver - Custom IPTables Configuration               #
################################################################################

*filter
:INPUT ACCEPT [0:0]
:FORWARD ACCEPT [0:0]
:OUTPUT ACCEPT [0:0]
-A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
-A INPUT -p icmp -j ACCEPT
-A INPUT -i lo -j ACCEPT

# SSH
-A INPUT -m state --state NEW -m tcp -p tcp --dport 22 -j ACCEPT

# Web
-A INPUT -p tcp --dport 80 -j ACCEPT

-A INPUT -j REJECT --reject-with icmp-host-prohibited
-A FORWARD -j REJECT --reject-with icmp-host-prohibited
COMMIT

################################################################################
" > /etc/sysconfig/iptables
systemctl restart iptables

