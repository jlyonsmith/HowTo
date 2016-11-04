# Validate SSL Certificate

To validate an SSL certificate with OpenSSL:

```bash
openssl verify -CAfile certificate-chain.crt certificate.crt
```

`certificate-chain.crt` must be just the original CA bundle, not the combined chain.  If the response is anything other than OK then there is a problem.

To check the dates the certificate is valid:

```bash
openssl x509 -noout -in certificate.crt -dates
```

# Re-issuing a Certificate

