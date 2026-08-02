## Client

Install with:
```bash
curl -sf https://binaries.nats.dev/nats-io/natscli/nats@latest | sh
sudo chown root:root nats
sudo mv nats /usr/bin
```
## Server

> NOTE: There is a bug in the script to install the latest NAT.  Instead go to [NATS Server Releasen](https://github.com/nats-io/nats-server/releases) and find the latest release (without `-binary` at the end) and use that if the `curl` command below fails, e.g. `v2.11.0`

Create a `nats` user and group:
```bash
sudo groupadd --system nats
sudo useradd --system --no-create-home --shell=/sbin/nologin -G nats nats
```
Install server tool:
```bash
curl -sf https://binaries.nats.dev/nats-io/nats-server/v2@latest | sh
sudo chown root:root nats-server
sudo mv nats-server /usr/bin
sudo mkdir /var/log/nats
sudo chown nats:nats /var/log/nats
```
Create a config file:
```bash
sudo touch /etc/nats-server.conf
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
nats context create admin
vi $HOME/.config/nats/admin.txt
nats context list
```

You need to create some users.  Edit `/etc/nats/nats-server.conf`:

```conf
accounts: {
    USERS: {
        users: [
            {user: user1, password: ...}
            {user: user2, password: ...}
        ]
    },
    SYS: { 
        users: [
            {user: admin, password: ...}
           ]
    },
}
system_account: SYS
```

Now `sudo systemctl restart nats`.  Then:

```sh
nats context create admin
```

Edit `$HOME/.config/nats/context/admin.json` and add:

```json
accounts: {
    USERS: {
        users: [
            {user: propctrl, password: odie}
            {user: propsrv, password: garfield}
        ]
    },
    SYS: { 
        users: [
            {user: admin, password: arbuckle}
           ]
    },
},
system_account: SYS
```

Do a `nats context select` to pick the default context.  Then you can do things like `nats server info`.

## Securing

To secure a NATS connection between a client and a server, you must mplement **TLS encryption for transit, strong authentication (such as NKeys or JWTs), and granular authorization rules**. Detailed setup instructions are available in the official [NATS Security Documentation](https://docs.nats.io/concepts/security). [1](https://oneuptime.com/blog/post/2026-01-27-nats-security/view), [2](https://docs.nats.io/learn/security/), [3](https://github.com/nats-io/nats.net/discussions/231), [4](https://www.youtube.com/watch?v=zBTURHjuI0Q&t=65), [5](https://www.scaleway.com/en/docs/nats/api-cli/nats-cli/)

1. Encrypting Traffic with TLS

Configure the NATS server (`nats-server.conf`) to require TLS, ensuring data is hidden in transit: [1](https://docs.nats.io/using-nats/developer/connecting/tls), [2](https://docs.nats.io/running-a-nats-service/configuration/securing_nats/tls), [3](https://docs.nats.io/learn/security/), [4](https://www.youtube.com/watch?v=zBTURHjuI0Q&t=65)

```hcl
tls {
  cert_file: "/path/to/server-cert.pem"
  key_file:  "/path/to/server-key.pem"
  ca_file:   "/path/to/ca-cert.pem"
  verify:    true  # Enforces Mutual TLS (mTLS) for client verification
  min_version: "1.2"
}
```

- Clients must use a `tls://` or `nats://` connection string configured with the matching CA certificate.

- Enable `verify: true` for mTLS so the server validates client certificates. [1](https://docs.nats.io/concepts/security), [2](https://www.youtube.com/watch?v=zBTURHjuI0Q&t=65), [3](https://docs.nats.io/using-nats/developer/connecting/tls), [4](https://oneuptime.com/blog/post/2026-01-27-nats-security/view)

2. Implementing Authentication

Choose a secure method to verify client identity instead of plain-text passwords: [1](https://docs.nats.io/learn/security/encryption)

- **NKeys (Public-Key Signatures):** The server stores a public NKey, and the client signs a server nonce with its private seed so secrets never cross the wire.
        
```hcl
authorization {
  users = [
    { nkey: "UDXU4RCVJ5K7MONFUQ2WFP3QZJWLQVZ3AQKJ7HNVQXKFZJQXQZQXQZQX" }
  ]
}
```
        
[1](https://docs.nats.io/learn/security/authentication-basics), [2](https://dev.to/karthiknayak/securing-nats-with-nkey-authentication-a-complete-guide-g48)

- **JWT / Decentralized Auth:** Use signed JSON Web Tokens managed via NATS account tools (`nsc`) for large, distributed multi-tenant environments. [1](https://dale-bingham-soteriasoftware.medium.com/using-nats-to-implement-service-mesh-functionality-part-2-security-e963d63583f8), [2](https://www.synadia.com/blog/onboarding-distributed-nats-clients-nkeys-jwts)

3. Configuring Authorization

Restrict what authenticated clients can publish or subscribe to by defining explicit subject permissions: [1](https://docs.nats.io/running-a-nats-service/configuration/securing_nats), [2](https://docs.nats.io/learn/security/)

```hcl
authorization {
  users = [
    {
      nkey: "UDXU4RCVJ5K7MONFUQ2WFP3QZJWLQVZ3AQKJ7HNVQXKFZJQXQZQXQZQX"
      permissions = {
        publish = {
          allow = ["metrics.>", "orders.us"]
        }
        subscribe = {
          allow = ["commands.us.>"]
        }
      }
    }
  ]
}
```
