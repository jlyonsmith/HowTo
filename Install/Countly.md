# Installing Countly

## Installation

Run:

On Ubuntu, follow [Installing the Countly Server](https://support.count.ly/hc/en-us/articles/360036862332-Installing-the-Countly-Server):

```sh
sudo -s
cd /opt
wget -qO- http://c.ly/install | bash
```

Installation and process logs are in `/opt/countly/log`.

If you will be using Countly and MongoDB on the same server:

Go to the server http://<PUBLIC_IP_ADDRESS>/setup to create first Global Administrator account.

## Setting Up MongoDB

If you will be using MongoDB on another server:

 1. Setup MongoDB on another server using https://c.ly/install/mongodb
 2. Secure your MongoDB server: https://support.count.ly/hc/en-us/articles/360037445752-Securing-MongoDB
 3. Follow this instruction to point Countly to your MongoDB server https://support.count.ly/hc/en-us/articles/360037814871-Configuring-Countly

Additionally you can:

[Secure your server](https://support.count.ly/hc/en-us/articles/360037816431-Configuring-HTTPS-and-SSL) by configuring HTTPS with your certificate. Or use [Let’s encrypt to generate certificate](https://support.count.ly/hc/en-us/articles/360037816491-Installing-Let-s-Encrypt-for-HTTPS).

Familiarize yourself with [Countly command line](https://support.count.ly/hc/en-us/articles/360037444912-Countly-command-line)

Check out [troubleshooting guide](https://support.count.ly/hc/en-us/articles/360037816811-Troubleshooting) if you run into any problems.
