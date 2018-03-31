# Configure Postfix for mail forwarding

You can use `postfix` to forward mail from domains that you control the MX records for.

This how-to comes from following the [Setup mail forwarding in postfix](http://www.binarytides.com/postfix-mail-forwarding-debian/) post.

Take care. Mail servers on port 25 get attacked constantly.  A wide open SMTP mail server configuration _will_ be exploited.

The [Postfix documentation](http://www.postfix.org/postconf.5.html) is also useful.

## Configure DNS records

Go to the [AWS Console](https://console.aws.amazon.com) and create a new _Hosted Zone_ for the domain.

In [Namecheap](https://www.namecheap.com) go to the Domain tab and select _Custom DNS_ and copy in the nameservers from the AWS record set.

Configure a new A record set for the domain, pointing it to the IP address of the server, e.g. `5.6.7.8`

Configure an MX record set for the domain, in the format `10 my-domain.com` The 10 is the priority of the mail server.

Run the `dig` command to ensure that the `A` and `MX` records are correct:

```
dig <domain> a
dig <domain> mx
```

When everything has propagated correctly, proceed to setting up `postfix`.

## Install `postfix`

On the server, run:

```
sudo apt-get install postfix
```

For the default domain name, use `<system>.<domain>`.  

Find the location of the `config_directory` with:

```
postconf | grep config_directory
```

Usually this is `/etc/postfix`.  First, let's turn off backward compatibility to avoid messages in the log:

```
sudo postconf compatibility_level=2
```

Now edit the main config file:

```
sudo vi /etc/postfix/main.cf
```

Set `myhostname=<machine>.<domain>`. Then add:

```
virtual_alias_domains = <domain> <my-other-domain>
virtual_alias_maps = hash:/etc/postfix/virtual
```

The `mydestination` parameter specifies what domains this machine will deliver locally, instead of forwarding to another machine.  It should contain `mydestination=$myhostname, <machine>, localhost.localdomain, localhost`.  That's it.

You can add multiple domains for `virtual_alias_domains` separated by spaces.  Now add a `virtual` file with `sudo vi /etc/postfix/virtual` and add:

```
# Emails to be forwarded

admin@<domain> person1@<otherdomain> person2@<otherdomain>
```

NOTE: You can use `@<domain>` to forward all emails, but *don't* because it breaks something called _recipient validation_.

Now generate the hash for the `virtual` file:

```
sudo postmap /etc/postfix/virtual
```

And reload `postfix` configuration:

```
sudo systemctl restart postfix
sudo systemctl status postfix
```

Check the log for errors.

Finally, if everything check out, configure the firewall to allow port 25 in:

```
sudo ufw allow smtp
```

Send a test email from another account.  You can watch `/var/log/mail.log` to see the email coming in and being processed through the server.
