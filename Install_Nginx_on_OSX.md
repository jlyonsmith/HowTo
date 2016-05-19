# Install `nginx` on OS X

Install `nginx`:

```bash
sudo brew install nginx
sudo nginx -?
```

Create a `launchctl` file

```bash
sudo edit /Library/LaunchDaemons/homebrew.mxcl.nginx.plist 
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

Lastly, restart `nginx` through launchctl to confirm all is working:

```bash
sudo launchctl load /Library/LaunchDaemons/homebrew.mxcl.nginx.plist 
```
