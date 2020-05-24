# Diagnosing Email Problems

## Yahoo

Yahoo is notorious for blocking email. Usually you get an email in the log:

```txt
421 4.7.0 [XXX] Messages from x.x.x.x temporarily deferred due to user complaints - 4.16.55.1
```

As described [here](https://help.yahoo.com/kb/postmaster/SLN3434.html). Yahoo has a page which describes [Bulk email industry standards and best practices](https://help.yahoo.com/kb/postmaster/recommended-guidelines-bulk-mail-senders-postmasters-sln3435.html).

1. Check that our email server IP address [Sender Score](https://www.senderscore.org/lookup.php?lookup=64.246.161.90&validLookup=true) is good.
2. Check the IP address is good on [spamhaus](https://www.spamhaus.org/query/ip/64.246.161.90)

If both of those are good the most likely culprit is that too many emails sent to Yahoo domains are bouncing.

Yahoo has a [Complaint Feedback Look](https://help.yahoo.com/kb/postmaster/complaint-feedback-loop-program-sln3438.html) program that you can sign up for.

There is also a useful [rackaid](https://www.rackaid.com/blog/how-to-remove-your-email-server-from-yahoos-blacklist/) article that links to a similar page to above.
