# Overview

A Docker container is lightweight virtualization of one or more processes using OS namespaces and control groups (`cgroups`).  It's also includes a system for "composing" containers out of additional packages and setup steps.

## Where's the SSH?

You don't SSH into a docker container.  You can run an instance of bash in a container using:

```sh
docker exec -it $CONTAINER_ID /bin/bash
```

You can use the 