# Uncomplicated Firewall

## Installation

Use [Uncomplicated Firewall](https://help.ubuntu.com/12.10/serverguide/firewall.html) to enable all ports, e.g.:

    sudu -s
    apt-get install ufw
    ufw allow ssh
    ufw enable

Add additional rules as necessary, e.g.

    ufw allow https
    ufw allow http

Or

    ufw reject http

See [Uncomplicated Firewall](https://wiki.ubuntu.com/UncomplicatedFirewall) for more information.

You can use the `$SSH_CONNECTION` environment variable to find your connection address:

    echo $SSH_CONNECTION

but not from the `sudo` shell.
