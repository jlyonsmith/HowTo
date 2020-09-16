# Get SSH Key RSA Fingerprints

There are both MD5 and SHA256 in use, typically on GitHub, BitBucket, etc..

SHA256 fingerprint:

```sh
ssh-keygen -lf ~/.ssh/id_rsa.pub
```

MD5 fingerprint:

```sh
ssh-keygen -l -E md5 -f ~/.ssh/id_rsa.pub
```
