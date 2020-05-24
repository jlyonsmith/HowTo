# `systemd` Configuration

Ubuntu 16.04 uses [Systemd](https://www.digitalocean.com/community/tutorials/systemd-essentials-working-with-services-units-and-the-journal) to manage daemons. Configuration files for `systemd` have a `.service` extension and are placed in the `/etc/systemd/system` directory. See also [`systemd` file format](https://www.freedesktop.org/software/systemd/man/systemd.service.html) `systemd` works alongside the existing Unix `/etc/init.d` and Upstart processes on Ubuntu.

A basic `.service` file might contain:

```service
[Unit]
Description=An API Service
After=network.target

[Service]
Type=simple
User=ubuntu
WorkingDirectory=/home/ubuntu/Xxx/Service
ExecStart=/usr/bin/node server.js
Restart=on-abort

[Install]
WantedBy=multi-user.target
```

Copy the `.service` file into the `/lib/systemd/system` directory:

```sh
sudo cp xxx.service /lib/systemd/system/
```

Enable and start the service with:

```sh
sudo systemctl --now enable xxx
```

You can see the status of the service with:

```sh
sudo systemctl status xxx
```

If the service file changes, reload it with:

```sh
sudo systemctl daemon-reload
```
