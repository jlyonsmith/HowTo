#!/bin/bash

######################
# Install Naviserver #
######################

cd /home/aolserv/source
tar -xzf naviserver-4.99.18.tar.gz

cd /home/aolserv/source/naviserver-4.99.18
sed -i 's|-O2|-O3|g' ./m4/tcl.m4
./autogen.sh \
        CFLAGS='-O3 -fno-builtin-malloc -fno-builtin-calloc -fno-builtin-realloc -fno-builtin-free' \
        LDFLAGS='-ljemalloc' \
        --prefix=/httpd/Naviserver49 \
        --exec-prefix=/httpd/Naviserver49 \
        --with-tcl=/httpd/components/tcl/lib \
        --enable-threads \
        --enable-shared \
        --disable-symbols \
        --enable-64bit \
        --disable-64bit-vis
sed -i 's|Ns_Log(Notice, "... sockAccept accepted %d connections", accepted);|/* Ns_Log(Notice, "... sockAccept accepted %d connections", accepted); */|' /home/aolserv/source/naviserver-4.99.18/nsd/driver.c
gmake
gmake install
mkdir /httpd/logs
mkdir /httpd/logs/traffic
chown aolserv.aolserv -R /httpd
rm -rf /httpd/Naviserver49/cgi-bin
rm -rf /httpd/Naviserver49/conf
rm -rf /httpd/Naviserver49/logs
rm -rf /httpd/Naviserver49/pages


