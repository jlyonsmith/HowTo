# Installing SSMTP Command Line Tool

## Ubuntu

```
sudo apt install ssmtp
```

## Configuration

Run `sudo vi /etc/ssmtp/ssmtp.conf` and add the address of the SMTP server:

```
mailhub=mail1.node.consul:25
```

## Test

Create a test email in `~/message.txt`:

```
Subject: Test email

Here is a test email.
```

Then run `ssmtp yourname@somewhere.com < ~/message.txt`.