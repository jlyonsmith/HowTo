# Decomissioning Services

This document list the steps required to decomission an Ubuntu service:

1. Remove `nginx` configuration
1. Stop service with `service xxx stop`
1. Remove `.conf` file from `/etc/...`
1. Delete `~/bin/` scripts
1. Delete sources from `/lib/xxx`
1. Remove Route53 DNS names (if necessary)
1. Stop auto-renew on domain names (if necessary)
