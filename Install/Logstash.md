# Logstash

Logstash is in intermediate service between Logbeats and ElasticSearch that can process & filter log entries before they are stored.

## Install

```bash
sudo apt install logstash
```

## Configuring

The configuration file for Logstash is at `/etc/logstash/logstash.yml`. `/etc/pipelines.yml` includes all pipeline scripts in `/etc/logstash/conf.d`.

## Reference

- [How To Install Elasticsearch, Logstash, and Kibana (Elastic Stack) on Ubuntu 18.04](https://www.digitalocean.com/community/tutorials/how-to-install-elasticsearch-logstash-and-kibana-elastic-stack-on-ubuntu-18-04)
- [Logstash Config for Filebeat](https://www.elastic.co/guide/en/logstash/6.6/logstash-config-for-filebeat-modules.html#parsing-nginx)
