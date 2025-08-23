## Summary

Consul is as distributed cloud monitoring and configuration solution.
## Ubuntu

```bash
export VER="1.4.4"
wget https://releases.hashicorp.com/consul/${VER}/consul_${VER}_linux_amd64.zip
unzip consul_${VER}_linux_amd64.zip
sudo chown root:root consul
sudo mv consul /usr/local/bin
```

Add group and user:

```bash
sudo groupadd --system consul
sudo useradd --shell /sbin/nologin --system --gid consul consul
```

Create consul configuration directory:

```bash
sudo mkdir -p /etc/consul/consul.d
sudo touch /etc/consul/consul.json
sudo chown -R consul:consul /etc/consul
```

Create consul data directory:

```bash
sudo mkdir -p /var/lib/consul
sudo chown -R consul:consul /var/lib/consul
sudo chmod -R ug=rwx,o=rx /var/lib/consul
```

Allow `consul` to listen to DNS on port 53:

```bash
sudo setcap 'cap_net_bind_service=+ep' $(which consul)
```

Ensure hostname is set correctly using `hostname <machine-name>`.

For the server nodes in the cluster put this in the `/etc/consul/consul.json`:

```json
{
  "acl": {
    "enabled": false
  },
  "server": false,
  "ui": false,
  "bind_addr": "{{GetAllInterfaces | include \"network\" \"10.10.0.0/16\" | attr \"address\"}}",
  "client_addr": "127.0.0.1",
  "datacenter": "dc1",
  "log_level": "INFO",
  "data_dir": "/var/lib/consul",
  "disable_update_check": false,
  "enable_syslog": true,
  "encrypt": "4VlHB0FEvpm0v1yILGrjVg==",
  "ports": {
    "dns": 53
  },
}
```

For the _first_ server node set:

```json
{
  "bootstrap": true
}
```

Then set to `false` after the cluster is running.

For a proxy server nodes, set:

```json
{
  "ui": true,
  "server": true,
  "recursors": ["8.8.8.8", "8.8.4.4"],
  "retry_join": ["10.10.1.2", "10.10.0.1"]
}
```

For the bastion server nodes:

```json
{
  "server": true,
  "retry_join": ["10.10.1.2", "10.10.0.1"]
}
```

For `systemd` support, copy this to `/lib/systemd/system/consul.service`:

```service
[Unit]
Description=Consul agent
Requires=network-online.target
After=network-online.target

[Service]
User=consul
Group=consul
PermissionsStartOnly=true
PIDFile=/var/run/consul/consul.pid
ExecStartPre=-/bin/mkdir -p /var/run/consul
ExecStartPre=/bin/chown -R consul:consul /var/run/consul
ExecStart=/usr/local/bin/consul agent \
    -config-file=/etc/consul/consul.json \
    -config-dir=/etc/consul/consul.d \
    -pid-file=/var/run/consul/consul.pid
ExecReload=/bin/kill -HUP $MAINPID
KillMode=process
KillSignal=SIGTERM
Restart=on-failure
RestartSec=30s

[Install]
WantedBy=multi-user.target
```

And `sudo systemctl enable consul` and `sudo systemctl start consul`. You can check that everything started with `journalctl -u consul -r`.

On Ubuntu, update `systemd-resolved` to use the Consul DNS server. Edit `/etc/systemd/resolved.conf` and ensure it contains:

```conf
DNS=127.0.0.1
Domains=~consul
```

And restart the service `systemctl restart systemd-resolved`.

On CentOS, make sure there are no `DNS` entries in any of the `/etc/sysconfig/network-scripts` interface definitions.  If there are, remove them.  The default on CentOS seems to be to default to using a DNS server running on `localhost:53`.

Test that DNS works:

```sh
dig <machine>.node.consul
```

## Adding a Service Definition

If a machine hosts a service, create a service file `/etc/consul/consul.d/<service-name>.json`, e.g.

```json
{
  "service": {
    "name": "fproxy",
    "id": "fproxy1",
    "port": 3128,
    "address": "",
    "tags": []
  }
}
```

## Generating New Machine id

Consul uses the `/etc/machine-id` value to identify hosts.  To generate a new one, do:

```sh
sudo rm /etc/machine-id
sudo systemd-machine-id-setup
```
