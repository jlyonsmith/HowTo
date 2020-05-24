# How to log into internal Proxmox and create a vm

1. Access local ProxMox (only available from FoxDen for now) at https://192.168.0.24:8006  If there are warnings, ignore them and continue
2. At the login screen, be sure to use ProxMox in the authentication realm. If you need login help, ask Darren or Codey. 
3. There is a base ubuntu 19.04 template already loaded with SSH keys already loaded. I recommend using that one. But if you want to run something else, you need to download the iso first and place it on the server.
4. Right click the template called `101 (ubuntu-template)` and select `clone`
5. For the template pop-up window: ![template](template1.jpeg)
   1. The `VM ID` is automatically generated but you can change it if you want. 
   2. Make the `name` something relevant (although you can change it later). 
   3. The `mode` **must** be `Full Clone`
   4. `Target Storage` should be set to `data` 
   5. `Format` should default to `QEMU` 
6. Click `Clone` and the VM will build, but not start.
7. The standard VM is set with very low resources. If you want to upgrade it, you must do so before it is started for the first time.
   1. Highlight the vm on the left menu
   2. Highlight the `Hardware` on the next menu
   3. Then select the hardware you want to change and click on the `edit` button
8. After you have selected the hardware you want, click on the start button on the top menu
9. Click the console button to watch the vm boot
10. Login in as `bptadmin` password is `bpt123!`
    1.  ![login](bptadmin.jpeg)
11. Change the hostname of the server by running the command `sudo ./changehostname.sh` and your vm will reboot
12. Log in again as `bptadmin` and take note of the IP address
13. You can now SSH directly with your private key
```
Darrens-MacBook-Pro@~> ssh -i .ssh/darrenj-bpt-4096 darrenj@192.168.0.38
The authenticity of host '192.168.0.38 (192.168.0.38)' can't be established.
ECDSA key fingerprint is SHA256:NxlTKI/XfJp+fFtkjdfF3cJqTlHuHrJXTNJBxGe5YsY.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added '192.168.0.38' (ECDSA) to the list of known hosts.
Welcome to Ubuntu 19.04 (GNU/Linux 5.0.0-38-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

  System information as of Mon Feb 24 11:52:32 PST 2020

  System load:  0.29               Processes:            109
  Usage of /:   16.3% of 14.74GB   Users logged in:      1
  Memory usage: 8%                 IP address for ens18: 192.168.0.38
  Swap usage:   0%


0 updates can be installed immediately.
0 of these updates are security updates.

Failed to connect to https://changelogs.ubuntu.com/meta-release. Check your Internet connection or proxy settings


Last login: Thu Feb 20 14:17:19 2020 from 192.168.0.46
darrenj@darren111:~$
```

    