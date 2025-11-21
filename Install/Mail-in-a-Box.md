# Installing Mail-in-a-Box

[Read the instructions](https://mailinabox.email/)

Basically, run `curl -s https://mailinabox.email/setup.sh | sudo -E bash` after setting up your Ubuntu box.

## Configuring S3 Backups

In AWS console configure:

- A backup group with an inline policy (see below)
- A backup user in that group
- An S3 backup bucket
- A folder in the bucket (called anything - `backups` will do)

Create an access key and secret access key for the user.  Paste the access key into the `~/.aws/credentials` file and set the region for the `default` user in the `~/.aws/config` file.  Install AWS CLI with `apt install awscli`, then test with `aws s3 ls $BUCKET_NAME`.

If that works, select the region, paste `{{BUCKET_NAME}}/{{FOLDER_NAME}}`, access id and secret access id into the Mail-in-a-Box backup page and if all is well, you'll get an OK message and backups will start happening to S3.

## References

- [Mail-in-a-box Duplicity Issue Nov-2025](https://discourse.mailinabox.email/t/duplicity-oops-they-did-it-again/16051)
