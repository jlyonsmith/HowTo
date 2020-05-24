# Install Filebeat

## Installation

```bash
mkdir ~/downloads
cd ~/downloads
wget https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-7.1.1-amd64.deb
sudo dpkg -i filebeat-7.1.1-amd64.deb
sudo systemctl enable filebeat
```

## Configure

Filebeat can send data directly to ElasticSearch (which is the default) However we are using Logstash
as our aggregator/filter/enhancer so edit the configuration as follows:

```bash
cd /etc/filebeat
sudo vi filebeat.yml
```

And add the following:

```yaml
output.logstash:
  # The Logstash hosts
  hosts: ["<filestash-host>:5044"]
```

## Manual Log Definition

It's a good idea to keep the log configs for each service in separate files. To do this, create config directory in `/etc/filebeat`:

```bash
cd /etc/filebeat
sudo mkdir configs.d`
```

The add to `/etc/filebeat/filebeat.yml`:

```yaml
```

The, for `postfix` for example, add config file:

```bash
sudo vi /etc/filebeat/configs.d/postfix.yml
```

And add:

```yaml
filebeat.inputs:
  enabled: true
  path: ${path.config}/configs.d/*.yml
```

And restart with `sudo systemctl restart filebeats`.

## Off-the-shelf Modules for Standard Services

To enable off-the-shelf modules stored in `/etc/filebeat/modules.d` edit `/etc/filebeat/filebeat.yml`:

```yaml
filebeat.config.modules:
  path: ${path.config}/modules.d/*.yml
```

For machines running `nginx` run:

```bash
filebeat modules enable nginx
```

This simply renames the `nginx.yml.disabled` to `nginx.yml` to activate it.

For more details on how nginx logs are prepared to send to logstash look in `/usr/share/filebeat/modules.d/nginx/access/ingest/default.json`. To see what logs are collected, see `/usr/share/filebeat/modules.d/nginx/access/config/nginx-access.yml`

## Debugging

Start Logbeat directly and show the log to STDOUT:

```bash
filebeat -e
```

There are also log verbosity settings in the `filebeat.yml` file.

## Reference

- [Introduction to Filebeat Tutorial](https://www.elastic.co/guide/en/beats/filebeat/current/filebeat-getting-started.html)
- [Install Filebeat](https://www.elastic.co/guide/en/beats/filebeat/current/filebeat-installation.html).
- [Filebeat Modules](https://www.elastic.co/guide/en/beats/filebeat/master/configuration-filebeat-modules.html)
- [Elastic-Kibana-Postfix](https://github.com/ActionScripted/elastic-kibana-postfix)

```

```
