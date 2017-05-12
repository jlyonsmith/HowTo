# Installing RabbitMQ

## On macOS

To install RabbitMQ on macOS, run:

```
brew install rabbitmq
brew services start rabbitmq
```

You'll now have a `launchctl` file under `~/Library/LaunchAgents/homebrew.mxcl.rabbitmq.plist`.  Look in that file to see where the configuration file is, but typically it is in `/usr/local/etc/rabbitmq/rabbitmq-env.conf`.
