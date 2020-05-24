# SystemD Services

## Remove a Service

```sh
systemctl stop <serviceName>
systemctl disable <serviceName>
rm /etc/systemd/system/<serviceName>
systemctl daemon-reload
systemctl reset-failed
```
