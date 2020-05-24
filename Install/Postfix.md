# Configure Postfix for mail forwarding

You can use `postfix` to forward mail from domains that you control the MX records for.

This how-to comes from following the [Setup mail forwarding in postfix](http://www.binarytides.com/postfix-mail-forwarding-debian/) post.

Take care. Mail servers on port 25 get attacked constantly. A wide open SMTP mail server configuration _will_ be exploited.

The [Postfix documentation](http://www.postfix.org/postconf.5.html) is also useful.

## Configure DNS records

Go to the [AWS Console](https://console.aws.amazon.com) and create a new _Hosted Zone_ for the domain.

In [Namecheap](https://www.namecheap.com) go to the Domain tab and select _Custom DNS_ and copy in the nameservers from the AWS record set.

Configure a new A record set for the domain, pointing it to the IP address of the server, e.g. `5.6.7.8`

Configure an MX record set for the domain, in the format `10 my-domain.com` The 10 is the priority of the mail server.

Run the `dig` command to ensure that the `A` and `MX` records are correct:

```bash
dig <domain> a
dig <domain> mx
```

When everything has propagated correctly, proceed to setting up `postfix`.

## Install `postfix`

On the server, run:

```bash
sudo apt-get install postfix mailutils
```

For the default domain name, use `<system>.<domain>`.

Find the location of the `config_directory` with:

```bash
postconf | grep config_directory
```

Usually this is `/etc/postfix`. First, let's turn off backward compatibility to avoid messages in the log:

```bash
sudo postconf compatibility_level=2
```

Now edit the main config file:

```bash
sudo vi /etc/postfix/main.cf
```

Set `myhostname=<machine>.<domain>`. Then add:

```bash
virtual_alias_domains = <domain> <my-other-domain>
virtual_alias_maps = hash:/etc/postfix/virtual
```

The `mydestination` parameter specifies what domains this machine will deliver locally, instead of forwarding to another machine. It should contain `mydestination=$myhostname, <machine>, localhost.localdomain, localhost`. That's it.

You can add multiple domains for `virtual_alias_domains` separated by spaces. Now add a `virtual` file with `sudo vi /etc/postfix/virtual` and add:

```bash
# Emails to be forwarded

admin@<domain> person1@<otherdomain> person2@<otherdomain>
```

NOTE: You can use `@<domain>` to forward *all* emails, but *don't* because it breaks *recipient validation*.

Now generate the hash for the `virtual` file:

```bash
sudo postmap /etc/postfix/virtual
```

And reload `postfix` configuration:

```bash
sudo systemctl restart postfix
sudo systemctl status postfix
```

Check the log for errors.

Finally, if everything check out, configure the firewall to allow port 25 in:

```bash
sudo ufw allow smtp
```

Send a test email from another account. You can watch `/var/log/mail.log` to see the email coming in and being processed through the server.

## Test Outbound Mail

Go to another machine that is connected to the same network as the Postfix server. Run `telnet`:

```bash
telnet <mail-server> smtp
Trying 1.2.3.4...
Connected to <mail-server>.
Escape character is '^]'.
220 <mail-server> ESMTP Postfix (Ubuntu)
EHLO your-domain
250 <mail-server>
MAIL FROM:<yourname@your-domain.com>
250 2.1.0 Ok
RCPT TO:<yourname@your-domain>
250 2.1.5 Ok
DATA
354 End data with <CR><LF>.<CR><LF>
Hey, just a test
.
250 2.0.0 Ok: queued as 1BAD34C1104
QUIT
221 2.0.0 Bye
Connection closed by foreign host.
```

If all is well, you should get an email at `yourname@gmail.com`.

Here is another way to test:

```bash
echo "This is a test email to check if DKIM works" | mailx -s "Test" -r admin@brownpapertickets.com -S smtp=smtp://mail1.node.consul -S from="admin@brownpapertickets.com<Admin>" QmAPEhDCj4PdvY@dkimvalidator.com
```

## PTR Record

Make request to you ISP to add a reverse PTR record.

## SPF Record

Use the [SPF Wizard](https://www.spfwizard.net/) to generate an SPF record and add it to the DNS records for the domain.

## DKIM Record

Install DKIM tools:

```bash
sudo apt install opendkim opendkim-tools
```

You need to choose an arbitrary DKIM _selector_ name.  In this case we choose `key1`.  Update the `/etc/opendkim.conf` file to contain:

```conf
# Commonly-used options; the commented-out versions show the defaults.
#
Selector key1
Canonicalization simple
Mode sv
SubDomains no

# Map AuthorDomains to RSA keys.
#
KeyTable /etc/dkimkeys/rsakeys.table
SigningTable refile:/etc/dkimkeys/signingdomains.table

# Entries from https://www.postfix.io/how-to-configure-opendkim-with-postfix/
#
AutoRestart yes
AutoRestartRate 10/1M
Background yes
DNSTimeout 5
SignatureAlgorithm rsa-sha256
OversignHeaders From
InternalHosts 127.0.0.1,10.0.0.0/16
ExternalIgnoreList 127.0.0.1,10.0.0.0/16
```

Generate RSA key:

```bash
cd /etc/dkimkeys/
opendkim-genkey --bits=1024 --selector=key1 --domain=<domain> --append-domain
```

Rename the files:

```bash
mv key1.private key1.<domain>.rsa
mv key1.private key1.<domain>.txt
```

Add the `TXT` record given in the `.txt` file to the DNS entry for `<domain>`.

Add to `/etc/dkimkeys/rsakeys.table`:

```bash
<domain-key> <domain>:key1:/etc/dkimkeys/key1.<domain>.rsa
```

Add to `/etc/dkimkeys/signingdomains.table`:

```bash
*@<domain> <domain-key>
```

This says that any email from `@<domain>` should be signed with the `<domain-key>` key.

Create a sandboxed DKIM socket:

```bash
mkdir /var/spool/postfix/opendkim
```

Add `postfix` user to `opendkim` group:

```bash
sudo adduser postfix opendkim
```

Set file permissions:

```bash
chown -R opendkim:opendkim /etc/opendkim.conf /etc/dkimkeys
chown -R opendkim:opendkim /var/spool/postfix/opendkim
```

Add the socket to the `/etc/opendkim.conf` file `Socket` entry:

```conf
Socket local:/var/spool/postfix/opendkim/opendkim.sock
```

Add to `/etc/postfix/main.cf`:

```bash
# OpenDKIM
milter_default_action = accept
milter_protocol = 6
smtpd_milters = unix:opendkim/opendkim.sock
non_smtpd_milters = unix:opendkim/opendkim.sock
```

Restart services:

```bash
systemctl restart opendkim.service
systemctl restart postfix.service
```

Send test emails and monitor logs:

- You can check if the DKIM DNS is configured in DNS correctly at [DKIM Key Checker](https://protodave.com/tools/dkim-key-checker/).
- You can send an email with [dkimvalidator.com](https://dkimvalidator.com/) and see that DKIM & SPF are working as expected.
- There is a good write up [here](https://petermolnar.net/howto-spf-dkim-dmarc-postfix/) on how to debug issues.
- And another setup tutorial [here](https://www.skelleton.net/2015/03/21/how-to-eliminate-spam-and-protect-your-name-with-dmarc/)

## DMARC

Add this TXT record:

```txt
"v=DMARC1;p=quarantine;pct=100;rua=mailto:admin@<yourdomain>"
```

You will get daily emails containing XML reports on how your email is being percieved by other email servers.

## DNS Whitelist

Register your domain at [DNSWS.ORG](https://www.dnswl.org/).  You need to add a domain name and IP address ranges.
