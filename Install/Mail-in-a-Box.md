# Installing

Go ahead and [Read the instructions](https://mailinabox.email)

tl;dr: run `curl -s https://mailinabox.email/setup.sh | sudo -E bash` after setting up your Ubuntu box.
## Configuring S3 Backups

In the AWS console for your account configure:

- A backup group with an inline policy (see below)
- A backup user in that group
- An general purpose S3 backup bucket with public access disabled (`BUCKET_NAME`)

The recommended inline policy for the user is:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "VisualEditor0",
      "Effect": "Allow",
      "Action": [
        "s3:GetBucketPublicAccessBlock",
        "s3:PutObject",
        "s3:GetObject",
        "s3:ListBucket",
        "s3:DeleteObject",
        "s3:GetBucketLocation"
      ],
      "Resource": [
        "arn:aws:s3:::BUCKET_NAME/*",
        "arn:aws:s3:::BUCKET_NAME"
      ]
    }
  ]
}

```

Install AWS CLI.  The recommended way is 

```sh
curl -fsSL https://awscli.amazonaws.com/v2/install.sh | bash
```

See the [AWS Install Instructions](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html#getting-started-install-instructions) for more details.

Create an access key and secret access key for the user. Run `aws configure` to set the access key, token and region.

If that works, select the region, paste `{{BUCKET_NAME}}/` (you need the trailing slash to indicate the root of the bucket), access id and secret access id into the Mail-in-a-Box backup page and if all is well, you'll get an OK message and backups will start happening to S3.

To manually trigger and test the built-in [Duplicity](https://mailinabox.email/maintenance.html) backup script in Mail-in-a-Box (MIAB), run the following command as `root` or using `sudo` via SSH: [1](https://www.hosting.fr/en/helpdesk/anleitungen/server/personal-mail-server-with-mailinabox/), [2](https://mailinabox.email/maintenance.html)

```sh
sudo /root/mailinabox/management/backup.py
```

### Testing & Verifying Your Backups

By default, the backup script makes incremental backups. If you want to force a **full backup** immediately to test your connection to local storage or an external cloud bucket, append the `--full` flag:
```bash
sudo /root/mailinabox/management/backup.py --full
```

After running the script, log into your Mail-in-a-Box web admin dashboard (usually `https://box.yourdomain.com/admin`).

- Navigate to **System > Backup Status**.
- Verify that the timestamp matches your test run, and that no errors are listed.

You can test if Duplicity can read and decrypt your files without actually rewriting any system data. First, expose your backup secret key to the environment, and then run a verification command:

```bash
# Load your backup secret passphrase
export PASSPHRASE=$(sudo cat /home/user-data/backup/secret_key.txt)

# Verify the backup repository status
sudo -E duplicity collection-status s3:///BUCKET_NAME
```

## Redirect Root URL

To automatically redirect your **Mail-in-a-Box** root URL (e.g., `box.example.com` or `mail.example.com`) directly to the webmail login screen (`/mail`), you can use a hidden native feature that allows custom **nginx** configurations. [1](https://discourse.mailinabox.email/t/how-to-301-redirection/9273/3), [2](https://zechendorf.com/2023/08/06/mailinabox-domain-redirect)

The cleanest way to achieve this is by adding a custom Nginx configuration file for your subdomain.

Step 1: Create the Custom Configuration File

Log into your server via SSH and create a configuration file named exactly after your mail subdomain inside the user data directory. [1](https://zechendorf.com/2023/08/06/mailinabox-domain-redirect)

For example, if your mail URL is `box.example.com`, run:

```bash
sudo nano /home/user-data/www/box.example.com.conf
```

_(Replace `box.example.com` with your actual mail subdomain.)_

Step 2: Add the Redirect Directive

Paste the following code into the file: [[1](https://zechendorf.com/2023/08/06/mailinabox-domain-redirect)]

```nginx
location = / {
    return 301 https://$host/mail/;
}
```

_Note: Using `location = /` ensures that only the root domain is redirected, preventing it from interfering with your admin panel (`/admin`) or underlying API assets._

Save and close the file (in Nano, press `Ctrl+O`, `Enter`, then `Ctrl+X`).

Step 3: Rebuild the Configuration and Restart Nginx

For the changes to take effect, you must tell Mail-in-a-Box to regenerate its web routing configuration and then restart the webserver: [1](https://zechendorf.com/2023/08/06/mailinabox-domain-redirect)

```bash
sudo ~/mailinabox/tools/web_update
sudo systemctl restart nginx
```

Now, when you navigate to your root mail URL, it will immediately pass a **301 Permanent Redirect** to the webmail page. [1](https://discourse.mailinabox.email/t/how-to-301-redirection/9273/3), [2](https://zechendorf.com/2023/08/06/mailinabox-domain-redirect)
## References

- [Mail-in-a-box Duplicity Issue Nov-2025](https://discourse.mailinabox.email/t/duplicity-oops-they-did-it-again/16051)
- [Google DNS Cache Flushing Tool](https://developers.google.com/speed/public-dns/cache)
