# Install Rocket.Chat

Here we install a standalone Rocket.Chat server.  You can use an existing MongoDB and Nginx installation if available.  Install and harden an Ubuntu 20.04 instance. As always, start with:

```sh
sudo apt update
```

Configure an `A` record for your domain, e.g. `yourdomain.com`.  Wait for `dig` machine to return it.

Install and generate certificate:

```sh
sudo apt install certbot
sudo apt install python3-certbot-nginx
certbot certonly --nginx -d yourdomain.com
```

`sudo vi /etc/crontab` and add `30 9  * * 1 root  /usr/bin/certbot renew --quiet`.  Check the log at `/var/log/letsencrypt/letsencrypt.log` to ensure certificates are being renewed.

Install Nginx:

```sh
apt install nginx
cat << EOF |sudo tee -a /etc/nginx/conf.d/yourdomain.com.conf
# Upstreams
upstream backend {
    server 127.0.0.1:3000;
}

# HTTPS Server
server {
    listen 443 ssl;
    server_name yourdomain.com;

    client_max_body_size 10M; // Without this you can't upload images

    ssl_certificate /etc/letsencrypt/live/yourdomain.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/yourdomain.com/privkey.pem;

    location / {
        proxy_pass http://backend/;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection "upgrade";
        proxy_set_header Host $http_host;

        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forward-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forward-Proto http;
        proxy_set_header X-Nginx-Proxy true;

        proxy_redirect off;
    }
}
EOF
nginx -t
nginx -s reload
```

Open the firewall for ports `80` and `443` and restrict to your IP.

Install MongoDB 4.0:

```sh
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 9DA31620334BD75D9DCB49F368818C72E52529D4
echo "deb [ arch=amd64 ] https://repo.mongodb.org/apt/ubuntu bionic/mongodb-org/4.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.0.list
```

Install Node 14.x:

```sh
sudo apt-get -y update && sudo apt-get install -y curl && curl -sL https://deb.nodesource.com/setup_14.x | sudo bash -
sudo apt-get install -y build-essential mongodb-org nodejs graphicsmagick
sudo npm install -g inherits n && sudo n 14.18.2
```

Install Rocket.Chat:

```fish
cd (mktemp -d)
chown -R rocketchat:rocketchat .
curl -L https://releases.rocket.chat/latest/download -o ./rocket.chat.tgz
tar -xzf rocket.chat.tgz -C ./
chown -R rocketchat:rocketchat ./bundle
pushd bundle/programs/server
sudo -u rocketchat -- npm install
popd
mv ./bundle /opt/Rocket.Chat
systemctl start rocketchat
systemctl status rocketchat
```

Configure the Rocket.Chat service:

```sh
sudo useradd -M rocketchat && sudo usermod -L rocketchat
sudo mkdir /home/rocketchat
sudo chown -R rocketchat:rocketchat /home/rocketchat
sudo chown -R rocketchat:rocketchat /opt/Rocket.Chat
cat << EOF |sudo tee -a /lib/systemd/system/rocketchat.service
[Unit]
Description=The Rocket.Chat server
After=network.target remote-fs.target nss-lookup.target nginx.service mongod.service
[Service]
ExecStart=/usr/local/bin/node /opt/Rocket.Chat/main.js
StandardOutput=syslog
StandardError=syslog
SyslogIdentifier=rocketchat
User=rocketchat
Environment=MONGO_URL=mongodb://localhost:27017/rocketchat?replicaSet=rs01 MONGO_OPLOG_URL=mongodb://localhost:27017/local?replicaSet=rs01 ROOT_URL=https://yourdomain.com PORT=3000
[Install]
WantedBy=multi-user.target
EOF
```

NOTE: Change `ROOT_URL` to be your HTTPS domain. Also, there is a bug that if you install a reverse proxy in front of Rocket.Chat after initially running it on port 3000 you will need to **manually** change the MongoDB configuration.  See [Rocket Chat - Change ROOT_URL and site URL](https://www.ryadel.com/en/rocket-chat-change-root_url-site-url-rocketchat/)

Initialize the MongoDB database:

```sh
sudo sed -i "s/^#  engine:/  engine: mmapv1/"  /etc/mongod.conf
sudo sed -i "s/^#replication:/replication:\n  replSetName: rs01/" /etc/mongod.conf
sudo systemctl enable mongod && sudo systemctl start mongod
mongo --eval "printjson(rs.initiate())"
sudo systemctl enable rocketchat && sudo systemctl start rocketchat
```

Immediately open the `https://yourdomain.com` and configure the admin user.  Unrestrict port `80` and `443` for any IP address.

## Upgrade

To upgrade:

```fish
#!/usr/bin/fish

if functions -q fish_is_root_user; and not fish_is_root_user
  echo 'Must be run as root'
  exit
end

cd (mktemp -d)
chown -R rocketchat:rocketchat .
curl -L https://releases.rocket.chat/latest/download -o ./rocket.chat.tgz
tar -xzf rocket.chat.tgz -C ./
chown -R rocketchat:rocketchat ./bundle
pushd bundle/programs/server
sudo -u rocketchat -- npm install
popd
mv ./bundle /opt/Rocket.Chat.Next
cd /opt
systemctl stop rocketchat
rm -rf Rocket.Chat.Previous
mv Rocket.Chat Rocket.Chat.Previous
mv Rocket.Chat.Next Rocket.Chat
systemctl start rocketchat
systemctl status rocketchat
```

NOTE: Use `n $NEW_VERSION` and `systemctl restart rocketchat` to upgraded NodeJS.

## Configuration

Make sure to set _Manually approve new users_ for any domains that are not in your *Whitelist domains*.

## Reference

- [Rocket.Chat Ubuntu Manual Installation](https://docs.rocket.chat/installation/manual-installation/ubuntu)