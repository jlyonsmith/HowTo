# Install AWS CLI

## Ubuntu

To install the [aws-cli](https://aws.amazon.com/cli/) tools:

```bash
sudo apt update
sudo apt install awscli
```

## macOS

```bash
brew install awscli
```

## Credentials

Create an `~/.aws` directory and put access keys and secret token from the AWS console in the `credentials` file.

```bash
cd ~
mkdir .aws
chown u=rwx,go=rx .aws
cd .aws
touch config
chmod u=rw,go= config
touch credentials
chmod u=rw,go= credentials
```

## Upload files to S3

To copy a file to S3:

```
aws s3 cp <backup-file> s3://com.yourdomain.backups/
```
