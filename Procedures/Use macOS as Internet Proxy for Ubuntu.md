## Summary

The easiest way to use your MacBook as an internet proxy for your Ubuntu system is by setting up an **SSH Dynamic Port Forwarding** (SOCKS) tunnel. This encrypts your traffic, requires no extra software, and routes your Ubuntu web and terminal traffic through the Mac's connection. 

### Step 1: Allow Remote Access on the MacBook

Your Ubuntu system needs permission to log into the Mac via SSH.

1. On your Mac, go to **System Settings** > **General** > **Sharing**.
2. Turn on **Remote Login** (this enables the built-in SSH server).
3. Click the "i" or Details button next to Remote Login to see your Mac's `username` and local IP address (e.g., `192.168.1.50`). [](https://support.apple.com/guide/mac-mini/use-mac-mini-as-a-server-apd05a94454f/mac)

### Step 2: Establish the Proxy Tunnel from Ubuntu

Open the terminal on your Ubuntu system and run the following command, replacing `mac_user` and `mac_ip_address` with your actual Mac credentials:

`ssh -D 1080 -N -f mac_user@mac_ip_address`

**Command Breakdown:**

- `-D 1080`: Opens a local SOCKS proxy on your Ubuntu machine at port `1080`.
- `-N`: Tells SSH not to execute any remote commands (only forwards ports).
- `-f`: Puts the SSH process in the background. [](https://www.justanswer.com/mac-computers/fptic-create-socks5-proxy-tunnel-using-ssh-server.html)

### Step 3: Configure Ubuntu to Use the Proxy

Now that the tunnel is open, you need to point Ubuntu's apps to the local port.

**For GUI traffic:**

1. Open Ubuntu’s **Settings** > **Network** > **Network Proxy**.
2. Set the configuration to **Manual**.
3. For **SOCKS Host**, enter `127.0.0.1` and Port `1080`. Leave the other proxy fields blank.

**For terminal traffic (APT, curl, etc.):**  

Export the standard proxy environment variables in your shell:

bash

```
export http_proxy="socks5h://127.0.0.1:1080"
export https_proxy="socks5h://127.0.0.1:1080"
```

