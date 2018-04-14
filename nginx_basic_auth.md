## Setting Up Basic Auth With `nginx`

Create a password file in the `root` directory of your site:

```Shell
sudo -s
apt-get install -y apache2-utils
cd <root-dir>
htpasswd -cb .htpasswd <user> <password>
```

Then, under the appropriate `location` in the sites `.conf` file:

```
server {
    listen 80 default_server;
    listen [::]:80 default_server ipv6only=on;

    root <root-dir>;
    index index.html index.htm;

    server_name localhost;

    location / {
        try_files $uri $uri/ =404;
        auth_basic "Restricted Content";
        auth_basic_user_file <root-dir>/.htpasswd;
    }
}
```
