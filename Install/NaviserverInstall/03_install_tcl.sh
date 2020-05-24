#!/bin/bash

###################
# Download Source #
###################

cd /home/aolserv/source
wget https://prdownloads.sourceforge.net/tcl/tcl8.6.9-src.tar.gz
wget https://github.com/tcltk/tcllib/archive/master.zip -O tcllib.zip
wget https://prdownloads.sourceforge.net/tclxml/tclxml-3.2.tar.gz
wget https://sourceforge.net/projects/tls/files/tls/1.6.7/tls1.6.7-src.tar.gz
wget https://prdownloads.sourceforge.net/next-scripting/nsf2.2.0.tar.gz
wget https://github.com/andreas-kupries/critcl/archive/master.zip -O critcl.zip

wget https://ftp.postgresql.org/pub/source/v9.6.12/postgresql-9.6.12.tar.gz

wget https://prdownloads.sourceforge.net/naviserver/naviserver-4.99.18.tar.gz
wget https://prdownloads.sourceforge.net/naviserver/naviserver-4.99.18-modules.tar.gz


###############
# Install TCL #
###############

cd /home/aolserv/source
tar -xzf tcl8.6.9-src.tar.gz
cd /home/aolserv/source/tcl8.6.9/unix
./configure \
        CFLAGS='-O3 -fno-builtin-malloc -fno-builtin-calloc -fno-builtin-realloc -fno-builtin-free' \
        LDFLAGS='-ljemalloc' \
        --prefix=/httpd/components/tcl \
        --enable-threads \
        --enable-shared \
        --disable-symbols \
        --enable-64bit \
        --disable-64bit-vis
sed -i 's|DUSE_THREAD_ALLOC=1|DUSE_THREAD_ALLOC=0|g' /home/aolserv/source/tcl8.6.9/unix/Makefile
gmake
gmake install
gmake install-headers
gmake install-private-headers
gmake install-libraries
chown aolserv.aolserv -R /httpd
echo "/httpd/components/tcl/lib" > /etc/ld.so.conf.d/BPT-LIBS-tcl.conf
ldconfig
echo 'export PATH=${PATH}:'"/httpd/components/tcl/bin" > /etc/profile.d/BPT-PATH-tcl.sh
source /etc/profile.d/BPT-PATH-tcl.sh

##################
# Install TCLLib #
##################

cd /home/aolserv/source
unzip tcllib.zip
cd /home/aolserv/source/tcllib-master
/httpd/components/tcl/bin/tclsh8.6 /home/aolserv/source/tcllib-master/installer.tcl -no-wait
chown aolserv.aolserv -R /httpd

##################
# Install TCLTLS #
##################

cd /home/aolserv/source
tar -xzf tls1.6.7-src.tar.gz
cd /home/aolserv/source/tls1.6.7
./configure \
        CFLAGS='-O3 -fno-builtin-malloc -fno-builtin-calloc -fno-builtin-realloc -fno-builtin-free' \
        LDFLAGS='-ljemalloc' \
        --prefix=/httpd/components/tcl/lib/tcltls \
        --exec-prefix=/httpd/components/tcl/lib/tcltls \
        --with-tcl=/httpd/components/tcl/lib \
        --enable-threads \
        --enable-shared \
        --disable-symbols \
        --enable-64bit \
        --disable-64bit-vis
gmake ; # Ignore the warnings
gmake install
chown aolserv.aolserv -R /httpd

###################################################
# Install Next Scripting Framework (NX and XOTcl) #
###################################################

yum -y install libbson libbson-devel mongo-c-driver mongo-c-driver-libs mongo-c-driver-devel
cd /home/aolserv/source
tar -xzf nsf2.2.0.tar.gz
cd /home/aolserv/source/nsf2.2.0
sed -i 's|-O2|-O3|g' ./m4/tcl.m4
sed -i 's|-O2|-O3|g' ./configure
sed -i 's|-O2|-O3|g' ./library/mongodb/configure
sed -i 's|-O2|-O3|g' ./library/mongodb/m4/tcl.m4
./configure \
        CFLAGS='-O3 -fno-builtin-malloc -fno-builtin-calloc -fno-builtin-realloc -fno-builtin-free' \
        CPPFLAGS="-I/home/aolserv/source/tcl8.6.9/generic" \
        LDFLAGS='-ljemalloc' \
        --prefix=/httpd/components/tcl \
        --exec-prefix=/httpd/components/tcl \
        --with-tcl=/httpd/components/tcl/lib \
        --with-tclinclude=/httpd/components/tcl/include \
        --enable-threads \
        --enable-shared \
        --disable-symbols \
        --enable-64bit \
        --disable-64bit-vis
gmake
gmake install
chown aolserv.aolserv -R /httpd

##################
# Install Critcl #
##################

cd /home/aolserv/source
unzip critcl.zip
cd /home/aolserv/source/critcl-master
/httpd/components/tcl/bin/tclsh8.6 build.tcl install /httpd/components/tcl/lib/critcl
chown aolserv.aolserv -R /httpd

echo 'export TCLLIBPATH="${TCLLIBPATH} /httpd/components/tcl/lib/critcl"' > /etc/profile.d/BPT-PATH-critcl.sh
source /etc/profile.d/BPT-PATH-critcl.sh
