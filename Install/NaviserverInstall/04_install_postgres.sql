#!/bin/bash


##################
# Install PDFLib #
##################

cd /home/aolserv/source
tar -xzf PDFlib-Lite-7.0.5p3.tar.gz
cd /home/aolserv/source/PDFlib-Lite-7.0.5p3
./configure \
        CFLAGS='-O3 -fno-builtin-malloc -fno-builtin-calloc -fno-builtin-realloc -fno-builtin-free' \
        LDFLAGS='-ljemalloc' \
        --with-tcl=/httpd/components/tcl/bin/tclsh8.6 \
        --with-tclpkg=/httpd/components/tcl/lib \
        --with-tclincl=/httpd/components/tcl/include \
        --enable-threads \
        --enable-shared \
        --disable-symbols \
        --enable-64bit \
        --disable-64bit-vis
gmake

sed -i 's|LIBS\t\t= $(DEPLIBS) $(TCLLIB)|LIBS\t\t= $(DEPLIBS) $(TCLLIB) -L/httpd/components/tcl/lib -ltcl8.6 -ltclstub8.6|' /home/aolserv/source/PDFlib-Lite-7.0.5p3/bind/pdflib/tcl/Makefile
sed -i 's|TCL_VERSION, 1|TCL_VERSION, 0|' /home/aolserv/source/PDFlib-Lite-7.0.5p3/bind/pdflib/tcl/pdflib_tcl.c
sed -i 's|#define USE_TCL_STUBS|#define USE_TCL_STUBS\n#define USE_INTERP_RESULT 1|' /home/aolserv/source/PDFlib-Lite-7.0.5p3/bind/pdflib/tcl/pdflib_tcl.c
sed -i 's|#if defined(_WRAP_CODE)|#define USE_INTERP_RESULT 1\n#if defined(_WRAP_CODE)|' /home/aolserv/source/PDFlib-Lite-7.0.5p3/bind/pdflib/tcl/tcl_wrapped.c

gmake install

cd /home/aolserv/source/PDFlib-Lite-7.0.5p3/bind/pdflib/tcl
gmake install
chown aolserv.aolserv -R /httpd/components/tcl


######################
# Install PostgreSQL #
######################

yum -y install libpqxx libxml2 libxml2-devel libxslt libxslt-devel perl-ExtUtils-CBuilder perl-ExtUtils-MakeMaker perl-ExtUtils-Embed readline-devel zlib-devel

cd /home/aolserv/source
tar -xzf postgresql-9.6.12.tar.gz

cd /home/aolserv/source/postgresql-9.6.12
./configure \
        CFLAGS='-O3 -fno-builtin-malloc -fno-builtin-calloc -fno-builtin-realloc -fno-builtin-free' \
        LDFLAGS='-ljemalloc' \
        --prefix=/httpd/components/pg \
        --exec-prefix=/httpd/components/pg \
        --with-tcl \
        --with-tclconfig=/httpd/components/tcl/lib \
        --with-perl \
        --with-libxml \
        --with-libxslt \
        --with-selinux \
        --with-pgport=2271 \
        --enable-thread-safety \
        --disable-debug
gmake
gmake install
chown aolserv.aolserv -R /httpd
