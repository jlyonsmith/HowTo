#!/bin/bash

################
# Install nsdb #
################

cd /home/aolserv/source/naviserver-4.99.18/nsdb
gmake install NAVISERVER=/httpd/Naviserver49
chown aolserv.aolserv -R /httpd


##################
# Install nsdbpg #
##################

cd /home/aolserv/source
tar -xzf naviserver-4.99.18-modules.tar.gz
mv /home/aolserv/source/modules /home/aolserv/source/naviserver-4.99.18/modules

cd /home/aolserv/source/naviserver-4.99.18/modules/nsdbpg
gmake \
        NAVISERVER=/httpd/Naviserver49 \
        PGLIB=/httpd/components/pg/lib \
        PGINCLUDE=/httpd/components/pg/include
gmake install \
        NAVISERVER=/httpd/Naviserver49 \
        PGLIB=/httpd/components/pg/lib \
        PGINCLUDE=/httpd/components/pg/include
chown aolserv.aolserv -R /httpd


#################
# Install nsdbi #
#################

cd /home/aolserv/source/naviserver-4.99.18/modules/nsdbi
sed -i 's|Log(handle, Notice, "closing %s handle, %d queries",|// Log(handle, Notice, "closing %s handle, %d queries",|g' init.c
sed -i 's|    reason, handlePtr->stats.queries);|//    reason, handlePtr->stats.queries);|g' init.c
sed -i 's|Log(handle, Notice, "opened handle %d/%d%s%s",|// Log(handle, Notice, "opened handle %d/%d%s%s",|g' init.c
sed -i 's|    handlePtr->n, poolPtr->maxhandles,|//    handlePtr->n, poolPtr->maxhandles,|g' init.c
sed -i 's|    msg ? ": " : "", msg ? msg : "");|//    msg ? ": " : "", msg ? msg : "");|g' init.c

gmake NAVISERVER=/httpd/Naviserver49
gmake install NAVISERVER=/httpd/Naviserver49
chown aolserv.aolserv -R /httpd

###################
# Install nsdbipg #
###################

cd /home/aolserv/source/naviserver-4.99.18/modules/nsdbipg
sed -i 's|Ns_Log(Notice, "dbipg: prepare %s/%u cols %u: %s",|// Ns_Log(Notice, "dbipg: prepare %s/%u cols %u: %s",|g' nsdbipg.c
sed -i 's|       stmtName, \*numVarsPtr, \*numColsPtr, stmt->sql);|//        stmtName, \*numVarsPtr, \*numColsPtr, stmt->sql);|g' nsdbipg.c

gmake \
        NAVISERVER=/httpd/Naviserver49 \
        PGLIB=/httpd/components/pg/lib \
        PGINCLUDE=/httpd/components/pg/include
gmake install \
        NAVISERVER=/httpd/Naviserver49 \
        PGLIB=/httpd/components/pg/lib \
        PGINCLUDE=/httpd/components/pg/include
chown aolserv.aolserv -R /httpd
