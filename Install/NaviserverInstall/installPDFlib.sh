cd /tmp
cp /var/git-clone/deploy/playbooks/roles/naviserver-bpt7h/files/PDFlib-Lite-7.0.5p3.tar.gz /tmp/
tar -xzf PDFlib-Lite-7.0.5p3.tar.gz
cd /tmp/PDFlib-Lite-7.0.5p3
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

sed -i 's|LIBS\t\t= $(DEPLIBS) $(TCLLIB)|LIBS\t\t= $(DEPLIBS) $(TCLLIB) -L/httpd/components/tcl/lib -ltcl8.6 -ltclstub8.6|' /tmp/PDFlib-Lite-7.0.5p3/bind/pdflib/tcl/Makefile
sed -i 's|TCL_VERSION, 1|TCL_VERSION, 0|' /tmp/PDFlib-Lite-7.0.5p3/bind/pdflib/tcl/pdflib_tcl.c
sed -i 's|#define USE_TCL_STUBS|#define USE_TCL_STUBS\n#define USE_INTERP_RESULT 1|' /tmp/PDFlib-Lite-7.0.5p3/bind/pdflib/tcl/pdflib_tcl.c
sed -i 's|#if defined(_WRAP_CODE)|#define USE_INTERP_RESULT 1\n#if defined(_WRAP_CODE)|' /tmp/PDFlib-Lite-7.0.5p3/bind/pdflib/tcl/tcl_wrapped.c

gmake install

cd /tmp/PDFlib-Lite-7.0.5p3/bind/pdflib/tcl
gmake install
chown aolserv.aolserv -R /httpd/components/tcl