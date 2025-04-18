## CLI

Install with:

```bash
curl -sf https://binaries.nats.dev/nats-io/natscli/nats@latest | sh
sudo chown root:root nats
sudo mv nats /usr/bin
```
## Server

> NOTE: There is a bug in the script to install the latest NAT.  Instead go to [NATS Server Releasen](https://github.com/nats-io/nats-server/releases) and find the latest release (without `-binary` at the end) and use that if the `curl` command below fails, e.g. `v2.11.0`

Install server tool:
```bash
curl -sf https://binaries.nats.dev/nats-io/nats-server/v2@latest | sh
sudo chown root:root nats-server
sudo mv nats-server /usr/bin
```

Create a `nats` user and group:

```bash
sudo useradd --system --no-create-home --shell=/sbin/nologin -G sudo nats
```

Create a config file:

```bash
sudo touch /etc/nats-server.conf
sudo chown root:root /etc/nats-server.conf
```

Create file `/etc/systemd/system/nats.service:

```toml
[Unit]
Description=NATS Server
After=network-online.target ntp.service

[Service]
PrivateTmp=true
Type=simple
ExecStart=/usr/bin/nats-server -c /etc/nats-server.conf
ExecReload=/bin/kill -s HUP $MAINPID
ExecStop=/bin/kill -s SIGINT $MAINPID
User=nats
Group=nats
# The nats-server uses SIGUSR2 to trigger using Lame Duck Mode (LDM) shutdown
KillSignal=SIGUSR2
# You might want to adjust TimeoutStopSec too.

[Install]
WantedBy=multi-user.target
```
Run `nats-server` on command line, then if all is well:

```bash
systemctl enable nats
systemctl start nats
```

## Configuration

For the command line tool you can configure *contexts* which is basically a server/user to communicate with when running commands:

```bash
nats context add controller --server nats.my.domain.com:4222 --description "My NATS server" --select
nats context list
```
`--select` makes this context the default.