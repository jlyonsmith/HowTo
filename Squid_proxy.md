# Squid as a proxy server

## Installation
- reference: https://www.tecmint.com/install-squid-in-ubuntu/

These are the instructions for installing `squid` as a forward proxy.

### Prerequisites
The machine hosting the forward proxy server must:

- Have access to internet
- Have NIC on internal network

These instructions were tested on Ubuntu 18.04.

```
sudo apt update
sudo apt install squid
sudo systemctl enable squid
sudo systemctl start squid
```
Log files are located at `/var/log/squid`

## Configuration 

Now edit the `/etc/squid/squid.conf` file. For our purposes, we can remove most of the commented lines. After editing, the file should look like this:
```
http_port 3128

acl manager proto cache_object
acl localhost src 127.0.0.0/32
acl safe_ports port 80 22 443
acl ssl_ports port 443
acl connect method CONNECT
acl mynetwork src 192.168.0.0/16

http_access allow manager localhost
http_access deny manager
http_access allow safe_ports
http_access deny !safe_ports
http_access deny connect !ssl_ports
http_access allow localhost
http_access allow mynetwork
http_access deny all
```
Restart squid.



## Client configuration

### linux machines
  
- General: append the `/etc/environment` file. Add the following lines:
    
```
http_proxy=http://<proxy DNS or IP>:3128/
https_proxy=http://<proxy DNS or IP>:3128/
```
  
- APT: edit (or create) the `/etc/apt/apt.conf.d/proxy.conf` file. Should look like:
  
```
Acquire::http::Proxy "http://<proxy DNS or IP>:3128 ";
Acquire::https::Proxy "http://<proxy DNS or IP>:3128 ";
```

- NPM: Set:

```
npm config set proxy $http_proxy
npm config set https-proxy $https_proxy
```  

- SSH: To use SSH through the proxy you must use the `ProxyCommand` option and the `nc` tool to tunnel through port 1080 on the proxy:

```
ssh -v -o ProxyCommand='nc <proxy-address> <proxy-socks-port>' git@bitbucket.org
```

- git: [How to Use Git Through a Proxy](http://cms-sw.github.io/tutorial-proxy.html)
