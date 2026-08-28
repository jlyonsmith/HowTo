## Overview

A Docker container is lightweight virtualization of one or more processes using OS namespaces and control groups (`cgroups`).  It's also includes a system for "composing" containers out of additional packages and setup steps.

## Where's the SSH?

You can SSH into a docker container, but it is simpler to run an instance of bash in the container instance using:

```sh
docker exec -it $CONTAINER_ID /bin/bash
```

You can use the ID number or the name, e.g. `gifted_davinci`, that is listed when you do `docker ps`.

