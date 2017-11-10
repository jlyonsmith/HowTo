## Setting Up Basic Auth With `nginx`

Create a password file in the `/etc/ngin` directory:

```Shell
sudo -s
cd /etc/nginx
touch .htpasswd
echo -n '<username>:' >> .htpasswd  # Supply appropriate <username>...
openssl passwd -apr1 >> .htpasswd
```

You will be prompted to enter and verify a password.

Then, under the appropriate `location` in the sites `.conf` file:

```
server {
    listen 80 default_server;
    listen [::]:80 default_server ipv6only=on;

    root /usr/share/nginx/html;
    index index.html index.htm;

    server_name localhost;

    location / {
        try_files $uri $uri/ =404;
        auth_basic "Restricted Content";
        auth_basic_user_file /etc/nginx/.htpasswd;
    }
}
```
