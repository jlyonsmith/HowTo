# RabbitMQ

## Install

Add APT repository public key:

```
wget -O- https://www.rabbitmq.com/rabbitmq-release-signing-key.asc | sudo apt-key add -
```

Add the repository to the `/etc/apt/sources.list.d` file:

```
echo 'deb http://www.rabbitmq.com/debian/ testing main' | sudo tee /etc/apt/sources.list.d/rabbitmq.list
```

Update and install the newest version of the server:

```
sudo apt-get update
sudo apt-get install rabbitmq-server
```

Test the server is running with:

```
sudo rabbitmqctl status
```

## Stop/Start

```
sudo systemctl enable rabbitmq-server
sudo systemctl start rabbitmq-server
sudo systemctl stop rabbitmq-server
```

## Security

By default RabbitMQ creates a `guest` account with password `guest` that only works for `localhost` connections. To connect from another system you need to add another account:

```
sudo rabbitmqctl add_user <name> <password>
sudo rabbitmqctl set_user_tags <name> administrator
sudo rabbitmqctl set_permissions -p / <name> ".*" ".*" ".*"
```

## Admin Functions

You can create, modify, delete and list queues and exchanges using `rabbitmqadmin`:

```bash
sudo rabbitmqadmin help subcommands
```

For example, to show all exchanges and whether they are durable or not:

```
sudo rabbitmqadmin list exchanges name durable
```
