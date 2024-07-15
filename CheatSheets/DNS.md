# DNS Records for Programmers

DNS is an old Internet standard that has some serious quirkiness.  It's also an important aspect of the Internet that many non-technical people have to understand, even in just a small way.  There is a shortage of "just tell me the rules" articles that programmers and other technical folks need. So, here goes.

## Registrars and Hosting Providers

A registrar is a company that you buy top level domain (TLD) names from.  The registrar controls the list of authoritative DNS servers for your TLD.

A hosting provider provides hosting services and often (in the case of AWS) DNS services as well.

## URL's

A URL is usually made up of several parts. To understand the structure and the components, we will dismantle the following example URL:

```
         ---------5-------
                       -4-
http://  www.  youtube.com  /watch   ?id=xya8esthaoeu8
--1----  -2-   -----3-----  --6---   --------7--------
```

1. Scheme or Protocol, e.g. http, https, ftp, mongodb, etc..
2. Sub-domain. Further qualifies the domain
3. Domain.  What you get from a registrar
4. The Top Level Domain.
5. Hostname.  May or may not include a sub-domain part.
6. Path.
5. Parameters or Search Parameters.

## `A` Records

An A record maps a hasname to 4-digit IPv4 addresses, e.g. 10.10.10.10. It's what all DNS queries finish with. If you specify multiple IP address the DNS server will generally round robin requests to each IP address.  Don't use this as a load balancing mechanism.

## `CNAME` Records

The allow you alias hostnames.  The rule for CNAME records is that there cannot be any other records for that hostname.  As a domain always has at least an NS and an SOA record, it is not allowed to have a CNAME for the domain itself.

CNAME must eventually resolved down to A records.  The CNAME doesn't replace anything in the URL of a web request.  The exact URL entered by the user will arrive at the web server.  It's simply a mechanism to find the underlying IP address for a domain name.

______

## Resetting DNS cache for End Users

### Windows 10
Right Click on the Start Icon.
Click on Command.
The Windows Command Prompt Window will appear. Type the following: ipconfig /flushdns
Press ENTER

### Windows 7
Right Click on the Start Icon.
Right Click on Command Prompt and select Run as Administrator.
The Windows Command Prompt Window will appear. Type the following: ipconfig /flushdns Press ENTER

### Mac OS 10.12 and later
Go to the Applications/Utilities folder and click on Terminal.
The Terminal window will appear.
In the command prompt, Type the following:
sudo killall -HUP mDNSResponder;sudo killall mDNSResponderHelper;sudo dscacheutil -flushcache
Press ENTER

### Mac OS 10.11
Go to the Applications/Utilities folder and click on Terminal.
The Terminal window will appear.
In the command prompt, Type the following:
sudo killall -HUP mDNSResponder
Press ENTER

### Linux
In the command prompt, Type the following:
sudo service nscd restart
Press ENTER

### iOS Phones and Tablets
Switch device to airplane mode.
Turn airplane mode off again

### Android Devices
Settings->Apps->Browser.
Go to “Storage”.
tap on “Clear Cache“.
