# audit commands - linux

Auditing is run on linux with the auditd daemon. This document is for searching and viewing the audit log. For info on installing and configuring, refer to the audit install page.

### handy auditing commands.
All auditing commands need to be run as root


| command | notes   | 
|---|---|
| aureport  |   |
| aureport  -ts today  | ts=time stamp  |
| aureport  -ts this-month|   |
| aureport  -c | configuration changes  |
| aureport  -au | authentication   |
| aureport  -l | logins  |
| aureport  -f | files  |
| aureport  -e | events   |
|   |   |
| ausearch -a <event id>  | details on an event   |
|   |   |
| auditctl -l   | list all audit rules  |
| auditctl -d  | delete all audit rules  |

### Example
```
darrenj@mongo1:~$ sudo auditctl -l
-a always,exit -S all -F dir=/var/log/audit/ -F perm=r -F auid>=1000 -F auid!=-1 -F key=10.2.3-access-audit-trail
-w /usr/sbin/ausearch -p x -k 10.2.3-access-audit-trail
-w /usr/sbin/aureport -p x -k 10.2.3-access-audit-trail
-w /usr/sbin/aulast -p x -k 10.2.3-access-audit-trail
-w /usr/sbin/aulastlogin -p x -k 10.2.3-access-audit-trail
-w /usr/sbin/auvirt -p x -k 10.2.3-access-audit-trail
-a always,exit -F arch=b64 -S setuid -F a0=0x0 -F exe=/usr/bin/su -F key=10.2.5.b-elevated-privs-session
-a always,exit -F arch=b32 -S setuid -F a0=0x0 -F exe=/usr/bin/su -F key=10.2.5.b-elevated-privs-session
-a always,exit -F arch=b64 -S setresuid -F a0=0x0 -F exe=/usr/bin/sudo -F key=10.2.5.b-elevated-privs-session
-a always,exit -F arch=b32 -S setresuid -F a0=0x0 -F exe=/usr/bin/sudo -F key=10.2.5.b-elevated-privs-session
-a always,exit -F arch=b64 -S execve -C uid!=euid -F euid=0 -F key=10.2.5.b-elevated-privs-setuid
-a always,exit -F arch=b32 -S execve -C uid!=euid -F euid=0 -F key=10.2.5.b-elevated-privs-setuid
-w /etc/group -p wa -k 10.2.5.c-accounts
-w /etc/passwd -p wa -k 10.2.5.c-accounts
-w /etc/gshadow -p wa -k 10.2.5.c-accounts
-w /etc/shadow -p wa -k 10.2.5.c-accounts
-w /etc/security/opasswd -p wa -k 10.2.5.c-accounts
-a always,exit -F arch=b32 -S stime,settimeofday,adjtimex -F key=10.4.2b-time-change
-a always,exit -F arch=b64 -S adjtimex,settimeofday -F key=10.4.2b-time-change
-a always,exit -F arch=b32 -S clock_settime -F a0=0x0 -F key=10.4.2b-time-change
-a always,exit -F arch=b64 -S clock_settime -F a0=0x0 -F key=10.4.2b-time-change
-w /etc/localtime -p wa -k 10.4.2b-time-change
-w /var/log/audit/ -p wa -k 10.5.5-modification-audit



darrenj@mongo1:~$ sudo aureport -ts today -f

File Report
===============================================
# date time file syscall success exe auid event
===============================================
1. 08/16/2019 06:27:03 /usr/libexec/netdata/plugins.d/perf.plugin 59 yes /usr/libexec/netdata/plugins.d/perf.plugin -1 8482
2. 08/16/2019 11:09:50 /usr/bin/sudo 59 yes /usr/bin/sudo 1005 8591
3. 08/16/2019 11:10:23 /usr/bin/sudo 59 yes /usr/bin/sudo 1005 8602
4. 08/16/2019 11:10:23 /var/log/audit 257 yes /sbin/aureport 1005 8609
5. 08/16/2019 11:10:23 /var/log/audit/audit.log 257 yes /sbin/aureport 1005 8610
6. 08/16/2019 11:10:23 /var/log/audit/audit.log 257 yes /sbin/aureport 1005 8611



darrenj@mongo1:~$ sudo ausearch -a 8482
----
time->Fri Aug 16 06:27:03 2019
type=PROCTITLE msg=audit(1565962023.812:8482): proctitle=2F7573722F6C6962657865632F6E6574646174612F706C7567696E732E642F706572662E706C7567696E0031
type=PATH msg=audit(1565962023.812:8482): item=1 name="/lib64/ld-linux-x86-64.so.2" inode=1835410 dev=08:01 mode=0100755 ouid=0 ogid=0 rdev=00:00 nametype=NORMAL cap_fp=0000000000000000 cap_fi=0000000000000000 cap_fe=0 cap_fver=0
type=PATH msg=audit(1565962023.812:8482): item=0 name="/usr/libexec/netdata/plugins.d/perf.plugin" inode=1710047 dev=08:01 mode=0104750 ouid=0 ogid=997 rdev=00:00 nametype=NORMAL cap_fp=0000000000000000 cap_fi=0000000000000000 cap_fe=0 cap_fver=0
type=CWD msg=audit(1565962023.812:8482): cwd="/etc/netdata"
type=EXECVE msg=audit(1565962023.812:8482): argc=2 a0="/usr/libexec/netdata/plugins.d/perf.plugin" a1="1"
type=SYSCALL msg=audit(1565962023.812:8482): arch=c000003e syscall=59 success=yes exit=0 a0=5591e0ed2b80 a1=5591e0ed2be8 a2=5591e25eac18 a3=5591e25ea010 items=2 ppid=24086 pid=24184 auid=4294967295 uid=997 gid=997 euid=0 suid=0 fsuid=0 egid=997 sgid=997 fsgid=997 tty=(none) ses=4294967295 comm="perf.plugin" exe="/usr/libexec/netdata/plugins.d/perf.plugin" key="10.2.5.b-elevated-privs-setuid"
```



### Docs
[aureport](https://linux.die.net/man/8/aureport)
[auditctl](https://linux.die.net/man/8/auditctl)
[ausearch](https://linux.die.net/man/8/ausearch)