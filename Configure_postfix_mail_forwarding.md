# Configure Postfix for mail forwarding

You can use `postfix` to forward mail from domains that you control the MX records for.

See [Setup mail forwarding in postfix](http://www.binarytides.com/postfix-mail-forwarding-debian/)

Take care. Mail servers on port 25 get attacked constantly.  A wide open SMTP mail server configuration _will_ be exploited.

The [Postfix documentation](http://www.postfix.org/postconf.5.html) is also useful.
