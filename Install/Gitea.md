# Install Gitea

[Gitea](https://gitea.io/) is a clean & functional self-hosted Git service.  Think GitHub, BitBucket or GitLabs but without the monthly payments.

## Installation

Create a clean Ubuntu 20.04 instance and lock it down.

If you have a private network, configure SSH to only allow the git user access by default and other users if they are coming in from the private IP range:

```conf
# Allow only git user
AllowUsers git

# Allow any user from internal network
Match Address 10.10.10.0/24
  AllowUsers *
```

Also, configure `iptables` to allow port 22 INPUT on both internal and external NICs.

Install Nginx and use Let's Encrypt to configure a key and certificate.

Install SQLite:

```bash
sudo apt update
sudo apt install sqlite3
```

Install Git:

```bash
sudo apt update
sudo apt install git
```

Create a Git user:

```bash
sudo adduser --system --group --disabled-password --shell /bin/bash --home /home/git --gecos 'Git Version Control' git
```

Download Gitea and install:

```bash
VERSION=1.14.2
sudo wget -O /tmp/gitea https://dl.gitea.io/gitea/${VERSION}/gitea-${VERSION}-linux-amd64
sudo mv /tmp/gitea /usr/local/bin
sudo chmod +x /usr/local/bin/gitea
```

> If you are upgrading Gitea, just run the above steps then `systemctl restart gitea`

Create directories and set ownership:

```bash
sudo mkdir -p /var/lib/gitea/{custom,data,indexers,public,log}
sudo chown git: /var/lib/gitea/{data,indexers,log}
sudo chmod 750 /var/lib/gitea/{data,indexers,log}
sudo mkdir /etc/gitea
sudo chown root:git /etc/gitea
sudo chmod 770 /etc/gitea
```

Create a `systemd` file:

```bash
sudo wget https://raw.githubusercontent.com/go-gitea/gitea/master/contrib/systemd/gitea.service -P /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl enable gitea
```

Configure Nginx as a reverse proxy for the site.  Configure the `app.ini`:

```ini
[server]
DOMAIN           = git.example.com
ROOT_URL         = https://git.example.com/

[mailer]
ENABLED = true
HOST    = SMTP_SERVER:SMTP_PORT
FROM    = SENDER_EMAIL
USER    = SMTP_USER
PASSWD  = YOUR_SMTP_PASSWORD
```

Then `sudo systemctl start gitea`.

Then browse the site and configure.

Afterwards, lock down the `app.ini`:

```bash
sudo chmod 750 /etc/gitea
sudo chmod 640 /etc/gitea/app.ini
```

## References

- [How to Install Gitea on Ubuntu](https://linuxize.com/post/how-to-install-gitea-on-ubuntu-18-04/)