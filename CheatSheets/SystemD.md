# SystemD Services

## Remove a Service

```sh
systemctl stop <serviceName>
systemctl disable <serviceName>
rm /etc/systemd/system/<serviceName>
systemctl daemon-reload
systemctl reset-failed
```

## Dependencies

Within the `[Unit]` section of your unit file or override configuration, add the appropriate directives: 

- **`Wants=other-service.service`**: This is a weak dependency. When your service is activated, `other-service` will also be activated. However, your service will still run even if `other-service` fails to start successfully. This is the recommended way for most custom dependencies.
- **`Requires=other-service.service`**: This is a stronger dependency. Both units will be activated together. If `other-service` fails to start, your service will also be deactivated (stopped).
- **`After=other-service.service`**: This defines the **ordering**, ensuring your service starts only _after_ `other-service` has been fully started and is active. This is crucial for services that need a resource (like a database or network interface) to be ready before they can function. `After=` does not implicitly activate the dependency; a `Wants=` or `Requires=` directive is typically used in conjunction with `After=` to ensure activation.
- **`Before=other-service.service`**: This has the opposite functionality of `After=`. It ensures your service is started _before_ `other-service`.