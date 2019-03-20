# Ordering an SSL Certificate

## Creating a Basic CSR

Keep all the following files in one directory and zip them up for safekeeping after the certificate is issued.

Let's say that you want to create certificate for the _domain name_:

    api.mydomain.com

We'll refer to this as the `<domain-name>`. Replace the dots (`.`) with underscores (`_`) and we'll refer to this as the `<file-name>`.

Create a signing configuration file, `<file-name>.cnf`:

```
[req]
default_bits = 2048
prompt = no
encrypt_key = no
default_md = sha384
distinguished_name = dn

[dn]
countryName = US
stateOrProvinceName = StateName
localityName = CityName
O.organizationName = OrganizationName
commonName = api.mydomain.com
emailAddress = admin@mydomain.com
```

Next, create the `.key` and the `.csr` file:

```bash
openssl req -new -newkey rsa -config <file-name>.cnf -keyout <file-name>.key -out <file-name>.csr
chmod o-rwx <file-name>.key
```

## CSR for VPN usage

For VPN usage you need to [add a little more to the signing request](https://blogs.technet.microsoft.com/rrasblog/2009/06/10/what-type-of-certificate-to-install-on-the-vpn-server/):

```
[req_v3]
keyUsage=digitalSignature,keyEncipherment
extendedKeyUsage=serverAuth
...
```

The above are just examples and the exact settings needed depend on the VPN software being used.

The full list of `keyUsage`/`extendedKeyUsage` settings are in the [OpenSSL Documentation](https://www.openssl.org/docs/manmaster/man5/x509v3_config.html).

To use this additional inforamtion you need to get OpenSSL to use it:

```
openssl req -new -newkey rsa -extensions req_v3 -config <file-name>.cnf -keyout <file-name>.key -out <file-name>.csr
```

## Certificate Re-issue

To re-issue a certificate use:

```bash
openssl req -new -newkey rsa -config <file-name>.cnf -keyout <file-name>.key -out <file-name>.csr
```

This `.csr` and `.key` can either be passed to a 3rd party for signing, or can be self signed.

Test the CSR is valid at [Symantec CryptoReport](https://cryptoreport.websecurity.symantec.com/checker/views/csrCheck.jsp).

## 3rd Party Signing

Take the `.csr` and `.key` files and order an SSL certificate on [Namecheap](http://namecheap.com). This will just require email verification.

For certificates ordered through [Comodo Positive SSL](http://positivessl.com) you will receive a collection of several individual certificates. These need to be concatenated together into a _bundle_ before deployment in _reverse order, from your domain to the highest level CA certificate_, e.g.:

    cat <file-name>.crt PositiveSSLCA2.crt AddTrustExternalCARoot.crt > <file-name>_chained.crt

or, if you get all the certificates in a `_chained` or `.ca-bundle` file:

    cat <file-name>.crt <file-name>.ca-bundle > <file-name>_chained.crt

See the [Comodo site][3] for concatenation details for different certificates. The files need to be concatenated in reverse order (root last).

On the server machine, create a `/etc/nginx/ssl` directory as `su`. `scp` the chained certificate and private key file up to the server into it using `~` as an intermediate directory.

### Self Signing

Self signing is really fast way to get an HTTPS site up and running, but you should order a 3rd party SSL certificate for any Internet facing site straight away. Sites signed this way will generate a warning in the browser when you go to them.

To use `openssl` to sign your certificate:

    openssl -req -x509 -days 365 -in <file-name>.csr -signkey <file-name>.key -out <file-name>.crt

This creates a certificate which expires in 1 year. See [here][2] for more information on self signing.

### Backup

Backup the `.csr`, `.key`, `.crt`, `.cnf` and `.csr` into an encrypted `.zip` file with a password. Ideally nobody, not even you, should ever see a private key, but that's another story.

### View Previous CSRs

At any point in the future you can see what information was in a CSR (in the `.csr` file) by running:

    openssl req -in <file-name>.csr -noout -text

### Reissue vs. Renew

**Renewing** a certificate can be done up to 30 days before the certificate expires. To renew, use the original CSR, not a new one. The new certificate expiration will be from when the the original certificate was going to expire, not the date of renewal. If you need to change any information on the certificate, you need to reissue _then_ renew.

**Reissuing** a certificate is an identical process to creating a new one except that the old certificate can be invalidated by the certificate issuer if you desire. You'll need to do this if the O or DN fields in the CSR change. Reissues expire when the original certificate expired.

### Exporting Certificate and Private Key from OS X Keychain

If you have a certificate that has been installed on the OS X Keychain application, you can extract it into a form that `nginx` can use with the following procedure:

1. Multi-select the certificate and all of the root certificates in the Keychain app. then **Export** them in `.p12` format to the Desktop.
2. In the `nginx/ssl` directory run:

   ```bash
   openssl pkcs12 -nokeys -in ~/Desktop/<cert-name>.p12 -out <site-name>_chained.crt
   openssl pkcs12 -nocerts -nodes -in ~/Desktop/<cert-name>.p12 -out <site-name>.key
   ```

3. You then need to open the files and reverse the certificate ordering in the `<site-name>_chained.crt` file, remove intermediate text and if necessary remove and duplicates of the private key in the `<site-name>.key` file.
4. Update your SSL config in the `.conf` file and run `nginx -t` to check all is well.

### Importing certificates for Mono

First, import and update root certificates on the machine:

    mozroots --import --sync

If you get an error connecting via SSL, try using `certmgr` to pull down the certificates for the site. For example:

    certmgr --ssl https://www.amazon.com

### Validate SSL Certificate

Check a certificate and return information about it (signing authority, expiration date, etc.):

```bash
openssl x509 -in <your-chained-certificate>.crt -text -noout
```

To check just the dates the certificate is valid:

```bash
openssl x509 -noout -in certificate.crt -dates -noout
```

---

[1]: http://nginx.org/en/docs/http/configuring_https_servers.html
[2]: https://www.switch.ch/grid/certificates/obtain/grid-csr-openssl.html
[3]: https://support.comodo.com/index.php?/Default/Knowledgebase/Article/View/620/0/which-is-root-which-is-intermediate
