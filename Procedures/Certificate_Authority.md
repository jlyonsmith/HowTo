# Create a personal Certificate Authority (CA) for signing your own TLS/SSL certificates

## Initialize

First, create a directory to save all the related files:

```sh
mkdir -p ca/root
cd ca/root
```

Create private key for the CA:

```sh
openssl genrsa -des3 -out MyCA.key 2048
chmod u=rwx,go= MyCA.key
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
localityName=My_Town
organizationName=My Org Name
[v3_req]
keyUsage=digitalSignature,keyCertSign
extendedKeyUsage=serverAuth,clientAuth
basicConstraints=critical,CA:true
```

> You can find the help for the `v3_req` flags with `man x509v3_config`, and for the other options at `man x509`.

The most important field is the Common Name (CN), which should be a company or other name, *not a Fully Qualified Domain Name (FQDN)*.  I recommend that you add **CA** or **Certificate Authority** as a suffix to this name so you can more easily identify your CA certificates.

Now generate the *root certificate*:

```sh
openssl req -x509 -new -nodes -extensions v3_req -key MyCA.key -sha256 -days 1825 -config MyCA.cnf -out MyCA.crt
```

The file `MyCA.crt` is your CA certificate in [PEM](https://en.wikipedia.org/wiki/Privacy-Enhanced_Mail) format.

## Installing the Root Certificate

Now you have the CA certificate you can install it once on every client that you will be accessing servers using certificates signed with this root one.  The server certificates will be trusted, and you will not get any more browser warnings. How you install depends on your O/S.

For example, on macOS `scp` the `MyCA.crt` file or otherwise copy it to the machine. The run `open MyCA.crt` in a terminal, or drag and drop the file to the **Keychain Access** app. This will add it to the **login** key chain under **Certificates**.  Right click on it, **Get Info** then select **Always trust**.

## Sign Certificates For Internal Sites

At this point you are ready to sign your own TLS/SSL certificates for any servers on your internal network.

First, create a working directory for the domain referred to as `{{DOMAIN}}` below:

```sh
mkdir -p ca/{{DOMAIN}}
cd ca{{DOMAIN}}
```

Now, you must create a *Certificate Signing Request* (CSR) for the Fully Qualified Domain Name (FQDN). We do this by creating a *signing configuration file* which we can then use to generate the binar CSR.

> The signing configuration file is a file containing the signing information as well as *extended* information about how the certificate can be used.  Signing information contains things like Common Name (CN), Organization Name, etc.. In older certificates you used the CN field to specify the FQDN, but for newer certificates Subject Alternate Name is how you are supposed to specify the domains you are allowed to sign.  This is since [RFC2818](https://tools.ietf.org/html/rfc2818), written in 2000.  If you don't supply this file to OpenSSL you'll get prompted for some of the information, but you'll still need to provide the *extended* signing information, i.e. a subset of the configuration file, ino order to generate the certificate properly.  So it's best to just create this file and make life easier.

So, create a file, `my.domain.cnf`, containing the following content:

```ini
[req]
default_md=sha256
prompt=no
distinguished_name=req_distinguished_name
[req_distinguished_name]
commonName=my.domain
countryName=US
stateOrProvinceName=Washington
localityName=Seattle
organizationName=My_Org_Name
[v3_req]
keyUsage=digitalSignature,keyEncipherment
extendedKeyUsage=serverAuth,clientAuth
basicConstraints=critical,CA:false
subjectAltName=DNS:my.domain
```

Now you have the configuration, here's the command to generate the `.csr` and a private `.key` file in one shot, using the `.cnf` file:

```sh
openssl req -out {{DOMAIN}}.csr -new -newkey rsa:2048 -keyout {{DOMAIN}}.key -nodes -config {{DOMAIN}}.cnf -extensions v3_req
```

The `-nodes` prevents DES encryption of the private key.  If you want to make a wildcard certificate, prefix both the `commonName` and the `DNS.0` name with `*.`.

> You can also generate a private key with the command `openssl genrsa -out {{DOMAIN}}.key 2048` and skip the `-newkey`, `-keyout`, `-nodes` arguments.

In theory, other people generate the `.csr` using the steps above then give it to you for signing. Your job is to prove you can trust them.  That's what being a Certificate Authority *is* after all.  You do the validation, then give them back a certificate, root certificate and a private key.  And maybe a shiney badge for their website.

> NOTE: there is an issue with CSR's that include *extensions*. These are extensions to the original CSR format. Any extensions specified in the CSR are not automatically copied over to a signed certificate. You need to create an extension file (`.ext`), a subset of the full `.cnf` file, and provide it to the `openssl x509` command with the `-extfile` flag and `-extensions`. For our own certificates, it's easiest to do that by using the `.cnf` file as the `.ext` file as `openssl` will ignore any sections it does not recognize for one format or the other!

The final step is to generate a signed `.crt` file to use for your internal site. You use the `x509` command to generate the certificate:

```bash
openssl x509 -req -in {{DOMAIN}}.csr -CA ../root/MyCA.crt -CAkey ../root/MyCA.key -CAcreateserial -out {{DOMAIN}}.crt -days 730 -sha256 -extfile {{DOMAIN}}.cnf -extensions v3_req
```

`-CAcreateserial` just causes a random number to be used as the certificate serial number. It will get written to a file named `.srl` in the same directory.

This certificate lasts 2 years. You'll take the files `my.domain.key` and `my.domain.crt` and install them on your server.

## Renewing Certificates

When the certificate expires you can renew it.  You can either use the same public/private key pair, or generate a new pair. If you want to use the same key pair again, do the following:

```sh
openssl req -out {{DOMAIN}}.csr -new -inkey {{DOMAIN}}.key -config {{DOMAIN}}.cnf -extensions v3_req
```

Otherwise, use the exact same command as when you are generating a certificate for the first time, as given in the previous section. Then, use the command as above to renew a certificate:

## Concatenating Certificates

Don't forget that for web servers such as `nginx`, this certificate needs to be concatenated together into a *chained certificate bundle* before deployment. You do this by concatenating the site certificate with the CA certificate (in that order), e.g.:

```bash
cat my.domain.crt ../root/MyCA.crt > my.domain/my.domain.chained.crt
```

Best practice is to just send the requester back your CA certificate along with the signed certificate and remind them of this detail.  It  dependends on where they are using the certificate.

## Generating a PKCS12 File

Many systems need a PKCS12 format file to import a certificate.  Generate one with:

```sh
openssl pkcs12 -export -out {{DOMAIN}}.pfx -inkey {{DOMAIN}}.key -in {{DOMAIN}}.crt -certfile ../root/MyCA.crt
```
