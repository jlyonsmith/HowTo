# Install `nginx` on OS X

Install `nginx`:

```bash
brew install nginx
nginx -?
```

Go into super user mode:

```bash
sudo -s
```

Create a `launchctl` file

```bash
edit /Library/LaunchDaemons/homebrew.mxcl.nginx.plist 
```

Paste the following into the file:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <dict>
    <key>Label</key>
    <string>homebrew.mxcl.nginx</string>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <false/>
    <key>ProgramArguments</key>
    <array>
        <string>/usr/local/opt/nginx/bin/nginx</string>
        <string>-g</string>
        <string>daemon off;</string>
    </array>
    <key>WorkingDirectory</key>
    <string>/usr/local</string>
  </dict>
</plist>
```

Create a log file directory:

```bash
mkdir -p /var/log/nginx
```

Create a simpler `nginx` configuration:

```
worker_processes 1;
error_log  /var/log/nginx/error.log;
events {
    worker_connections  1024;
}
http {
    include mime.types;
    default_type application/octet-stream;
    log_format main '$remote_addr - $remote_user [$time_local] "$request" '
      '$status $body_bytes_sent "$http_referer" '
      '"$http_user_agent" "$http_x_forwarded_for"';
    access_log/var/log/nginx/access.log  main;
    sendfile on;
    keepalive_timeout 65;
    include /usr/local/etc/nginx/conf.d/*;
}
```

Now you can your configurations in the `/usr/local/etc/nginx/conf.d/` directory.

Lastly, restart `nginx` through launchctl to confirm all is working:

```bash
launchctl load /Library/LaunchDaemons/homebrew.mxcl.nginx.plist 
```

# Checking What Process is Using a Port on OS X El Capitan

To see which process has a port open:

```
lsof -i tcp:3000
```
