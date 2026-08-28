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

To manually trigger and test the built-in [Duplicity](https://mailinabox.email/maintenance.html) backup script in Mail-in-a-Box (MIAB), run the following command as `root` or using `sudo` via SSH: [1](https://www.hosting.fr/en/helpdesk/anleitungen/server/personal-mail-server-with-mailinabox/), [2](https://mailinabox.email/maintenance.html)

```sh
sudo /root/mailinabox/management/backup.py
```

### Testing & Verifying Your Backups

1. Force a Full Backup Test [1](https://www.digitalocean.com/community/tutorials/how-to-use-duplicity-with-gpg-to-securely-automate-backups-on-ubuntu)

By default, the script takes incremental backups. If you want to force a **full backup** immediately to test your connection to local storage or an external cloud bucket, append the `--full` flag: [[1](https://discourse.mailinabox.email/t/backups-steps-and-requirements/11953), [2](https://discourse.mailinabox.email/t/duplicity-backup-configuration/12390), [3](https://www.techtarget.com/searchdatabackup/tutorial/How-to-use-the-duplicity-backup-tool)]

```bash
sudo /root/mailinabox/management/backup.py --full
```

Use code with caution.

2. Check the Status in the Control Panel

After running the script, log into your Mail-in-a-Box web admin dashboard (usually `https://box.yourdomain.com/admin`). [1](https://mailinabox.email/maintenance.html)

- Navigate to **System > Backup Status**.
- Verify that the timestamp matches your test run, and that no errors are listed. [[1](https://dme-libraries.s3.ap-southeast-1.amazonaws.com/End+user+portal+guide.pdf), [2](https://pattersonsupport.custhelp.com/app/answers/detail/a_id/15765/~/pattlock---manually-run-an-eaglesoft-backup-set)]

3. Test a Simulated Restore (Dry Run) [[1](https://www.infiniroot.com/blog/1038/email-migration-transfer-sync-using-imap-mailbox-imapsync)]

You can test if Duplicity can read and decrypt your files without actually rewriting any system data. First, expose your backup secret key to the environment, and then run a verification command: [1](https://discourse.mailinabox.email/t/restore-duplicity-files/7368), [2](https://mikeneumann.net/tech/build-and-restore-a-miab-server/)

```bash
# Load your backup secret passphrase
export PASSPHRASE=$(sudo cat /home/user-data/backup/secret_key.txt)

# Verify the backup repository status
sudo -E duplicity collection-status file:///home/user-data/backup/encrypted
```

_(If you use an external target like S3 or B2, swap `file:///...` with your target URL layout)._ [1](https://discourse.mailinabox.email/t/duplicity-backup-configuration/12390)
## References

- [Mail-in-a-box Duplicity Issue Nov-2025](https://discourse.mailinabox.email/t/duplicity-oops-they-did-it-again/16051)
