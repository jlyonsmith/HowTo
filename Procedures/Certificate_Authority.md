# Create a personal Certificate Authority (CA) for signing your own TLS/SSL certificates

## Initialize

First, create a directory to save all the related files:

```sh
mkdir -p ca/root
cd ca/root
```

Create private key for the CA:

```sh
openssl genrsa -des3 -out myCA.key 2048
chmod u=rwx,go= myCA.key
```

*Give it a pass-phrase for security. Write that down and keep it safe.*

Create a CSR config file in `MyCA.cnf:

```ini
[req]
default_md=sha256
prompt=no
req_extensions=v3_req
distinguished_name=req_distinguished_name
[req_distinguished_name]
commonName=My CA
countryName=US
stateOrProvinceName=Washington
localityName=Seattle
organizationName=My Org Name
[v3_req]
keyUsage=digitalSignature,keyCertSign
extendedKeyUsage=serverAuth,clientAuth
basicConstraints=critical,CA:true
```

> You can find the help for the `v3_req` flags with `man x509v3_config`, and for the other options at `man x509`.

The most important field is the Common Name (CN), which should be a company or other name, *not a Fully Qualified Domain Name (FQDN)*.  I recommend that you add **CA** or **Certificate Authority** as a suffix to this name so you can more easily identify you CA certificate.

Now generate the *root certificate*:

```sh
openssl req -x509 -new -nodes -extensions v3_req -key myCA.key -sha256 -days 1825 -config MyCA.cnf -out myCA.crt
```

The file `myCA.crt` is your CA certificate in [PEM](https://en.wikipedia.org/wiki/Privacy-Enhanced_Mail) format.

## Install on macOS

Now you have the CA certificate, you can install it once everywhere your certificates will be used and all certificates signed with it will be trusted.  No more browser warnings.

`scp` the `myCA.pem` file locally. Run `open myCA.pem`.  Add it to the login or System key chains.  Right click on it, **Get Info** then select **Always trust**.

## Sign Certificates For Internal Sites

Now you have your CA certificate created and distributed, you are ready to sign you own TLS/SSL certificates.

First, create a working directory and generate a key for the certificate:

```sh
mkdir -p ca/my.domain
cd ca/my.domain
openssl genrsa -out my.domain.key 2048
```

We next need to create a *Certificate Signing Request* (CSR) for the Fully Qualified Domain Name (FQDN). We do this by creating a *signing configuration file* which we can then use to generate the CSR.

> The signing configuration file is a file containing the signing information and extended information about how the certificate can be used.  Signing information are things like Common Name (CN), Organization Name, etc.. In older certificates you used the CN field to specify the FQDN, but for newer certificates Subject Alternate Name is how you are supposed to specify the domains you are allowed to sign.  This is since [RFC2818](https://tools.ietf.org/html/rfc2818), written in 2000.  If you don't give this file you'll get prompted for some of the information, but you'll still need to provide *extended signing information* (a subset of the configuration file) to generate the certificate properly.

So, create a file, `my.domain.cnf`, containing the following content:

```ini
[req]
default_md=sha256
prompt=no
distinguished_name=req_distinguished_name
[req_distinguished_name]
commonName=my.domain.key
countryName=US
stateOrProvinceName=Washington
localityName=Seattle
organizationName=My Org Name
[v3_req]
keyUsage=digitalSignature,keyEncipherment
extendedKeyUsage=serverAuth,clientAuth
basicConstraints=critical,CA:false
subjectAltName=@alt_names
[alt_names]
DNS.0=my.domain.key
```

Now you have configuration, here's the command to generate the `.csr` file using the `.cnf` file:

```sh
openssl req -new -key my.domain.key -config my.domain.cnf -out my.domain.csr -extensions v3_req
```

If you want to make a wildcard certificate add `*.` to both the `commonName` and the `DNS.0` name.

In theory, other people generate the `.csr` using the steps above give it to you for signing, if you trust them.  That's what being a Certificate Authority *is* after all.

> NOTE: there is an issue with CSR's that include extensions. Any extensions specified in the CSR are not automatically copied over to a signed certificate. You need to create an extension file (`.ext`), a subset of the full `.cnf` file, and provide it to the `openssl x509` command with the `-extfile` flag and `-extensions`. For our own certificates, it's easiest to do that by using the `.cnf` file as the `.ext` file.

The final step is to generate a signed `.crt` file to use for your internal site. We're using the `x509` command not the `req` command specifically (yeah, it's weird):

```sh
openssl x509 -req -in my.domain.csr -CA ../root/myCA.crt -CAkey ../root/myCA.key -CAcreateserial -out my.domain.crt -days 730 -sha256 -extfile my.domain.cnf -extensions v3_req
```

`-CAcreateserial` just causes a random number to be used as the certificate serial number.

This certificate lasts 2 years. You'll take the files `my.domain.key` and `my.domain.crt` and install them on your server.

Don't forget that for web servers such as `nginx`, this certificate needs to be concatenated together into a _chained certificate bundle_ before deployment. You do this by concatenating the site certificate with the CA certificate (in that order), e.g.:

```sh
cat my.domain.crt ../root/MyCA.crt > my.domain/my.domain.chained.crt
```

Best practice is to just send the requester back your CA certificate along with the signed certificate and remind them of this detail.  It's dependent on where they are using the certificate.
