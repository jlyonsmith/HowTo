# Forcing a Proxmox vm instance down

Occasionally a Proxmox vm will hang and can't be killed through the web interface. You can still kill it through the CLI

1. Log on to the proxmox server that is hosting the vm
2. Issue the `qm list` to confirm your vm ID
3. As root, issue the `qm shutdown <vmid> --forceStop`

```
root@compute1:~# qm list
      VMID NAME                 STATUS     MEM(MB)    BOOTDISK(GB) PID
       101 elastic1             running    8192              32.00 8941
       102 rabbit1              running    4096              32.00 2483
       103 actor1               running    8192              32.00 34566
       106 netdata1             running    8192              32.00 1184
       109 schedule1            running    8192              16.00 1588
       110 decrypt2             running    2048              16.00 27740
       112 legacy2              running    16384             16.00 11825
       114 mobile2              running    16384             16.00 33467
       120 mongo1               running    4096              32.00 48623
       126 mongo3               running    4096              32.00 6219
       144 elk1                 running    16384             32.00 13754
       146 snort1               running    8192              32.00 18401
       200 community1           running    8192              32.00 4668
       202 image1               running    4096              32.00 4953
       505 internalscan         stopped    8192              40.00 0
       510 internalscan20       stopped    8192              32.00 0
       666 bmanderino1          running    4096              32.00 29710
       668 glyphstone1          running    4096              32.00 29951
       700 ub-template          stopped    8192              32.00 0
       701 ubuntu-template-small stopped    8192              32.00 0
       703 ubuntu-template-medium stopped    8192              32.00 0
       888 bengold1             running    4096              32.00 29538
root@compute1:~# qm shutdown 112 --forceStop
VM still running - terminating now with SIGTERM
root@compute1:~#
```

Reference: https://pve.proxmox.com/pve-docs/qm.1.html