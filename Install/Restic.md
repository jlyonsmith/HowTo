# Restic Backup Software

Restic is a free, modern and easy to use Linux backup tool.

## Installation

```sh
apt install restic
```

## Configuration

### S3 Bucket

First, configure an S3 bucket, create a backup user and get the access & secret access keys.

1. Create the bucket, no versioning, ACL's or encryption needed
2. Create a backup IAM group and give it an inline policy like below
3. Create a backup user and assign them to the group
4. Add AWS credentials for the user and copy them down

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "ListObjectsInBucket",
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket"
            ],
            "Resource": [
                "arn:aws:s3:::your-backup-bucket"
            ]
        },
        {
            "Sid": "AllObjectActions",
            "Effect": "Allow",
            "Action": "s3:*Object",
            "Resource": [
                "arn:aws:s3:::your-backup-bucket/*"
            ]
        }
    ]
}
```

### Configure SystemD for Users

This document assumes you will be configuring Restic for a specific user, in this case a user called `git`.  We also assume that you have `systemd` installed and are using that for a running Restic (not `cron`).

First, become the `git` user with `sudo su git`.

Then, ensure that you have the required variables to run `systemd --user`.  Add the following to `.bashrc`:

```bash
export XDG_RUNTIME_DIR="/run/user/$UID"
export DBUS_SESSION_BUS_ADDRESS="unix:path=${XDG_RUNTIME_DIR}/bus"
```

### Configure Files to Backup

Create `~/.config/files-to-backup` with:

```txt
/etc/gitea/app.ini
/var/lib/gitea/custom
/var/lib/gitea/data
/var/lib/gitea/log
/home/git/gitea-repositories
```

These files are just an example for backing up a Gitea instance.

### Configure Restic Environment

Create `~/.config/restic-environment` with:

```conf
RETENTION_DAYS=7
RETENTION_WEEKS=4
RETENTION_MONTHS=6
RETENTION_YEARS=3
AWS_ACCESS_KEY=...
AWS_SECRET_ACCESS_KEY=...
RESTIC_REPOSITORY=s3:s3.us-west-2.amazonaws.com/your-backup-bucket
RESTIC_PASSWORD=...
```

Generate a `RESTIC_PASSWORD` with your favorite password generator and paste in the AWS access key information, and the correct bucket name for `your-backup-bucket`.

### Initialize the Repo

Run `export $(grep -v '^#' .config/restic-environment | xargs)` in your shell to get the needed environment variables, then run:

```bash
restic init
```

to initialize the repository for the first use.

### Test Backup

Do a test backup with `restic backup`.  Then do a `restic snapshots` and ensure your backup looks correct.

### Create Backup Service and Timer

Create a file `~/.config/systemd/user/restic-backup.service` with:

```conf
[Unit]
Description=Restic backup service

[Service]
Type=oneshot
ExecStart=restic backup --verbose --one-file-system --tag systemd.timer --files-from /home/git/.config/files-to-backup
ExecStartPost=restic forget --verbose --tag systemd.timer --group-by "paths,tags" --keep-daily $RETENTION_DAYS --keep-weekly $RETENTION_WEEKS --keep-monthly $RETENTION_MONTHS --keep-yearly $RETENTION_YEARS
WorkingDirectory=/home/git
EnvironmentFile=/home/git/.config/restic-environment
```

Test with `systemctl --user daemon-reload` then `systemctl --user start restic-backup.service`.

If a problem is reported set `StandardOutput=file:/home/git/restic-backup.out` and `StandardError=file:/home/git/restic-backup.err` and see what the output and errors are.  You can also try `ExecStart=/bin/bash -c 'env'` to see what the environment is set too.

Create a timer service:

```conf
[Unit]
Description=Daily Restic backup

[Timer]
OnCalendar=daily
Persistent=true

[Install]
WantedBy=timers.target
```

Enable the time with `systemctl --user enable restic-backup.timer`.

Check with `systemctl --user list-timers`.

### Create Prune Service and Timer

Add a separate pruning service that runs less frequently.  Add a file `~/.config/systemd/user/restic-prune.service`:

```conf
[Unit]
Description=Restic pruning service

[Service]
Type=oneshot
ExecStart=restic prune
EnvironmentFile=/home/git/.config/restic-environment
```

Again, `deaemon-reload` and `start`, then debug if needed.

Add a `~/.config/systemd/user/restic-prune.timer`:

```conf
[Unit]
Description=Restic backup service for Gitea (data pruning)

[Service]
Type=oneshot
ExecStart=restic prune
EnvironmentFile=/home/git/.config/restic-environment
```

Enable the time with `systemctl --user enable restic-prune.timer`.

Check with `systemctl --user list-timers`.

## References

- [Restic Documentation](https://restic.readthedocs.io/en/stable/index.html)
- [Automate backups with restic and systemd - Fedora Magazine](https://fedoramagazine.org/automate-backups-with-restic-and-systemd/)
- [sudo - Managing another user's systemd units - Unix & Linux Stack Exchange](https://unix.stackexchange.com/questions/245768/managing-another-users-systemd-units/245866#245866)
- [systemd.exec](https://www.freedesktop.org/software/systemd/man/systemd.exec.html)
- [systemd user services - unixsysadmin.com](https://www.unixsysadmin.com/systemd-user-services/)
