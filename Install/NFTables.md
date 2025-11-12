
## Installation

NFTables is the default firewall on Debian 13 and Ubuntu 24.04.

Don't forget to uncomment the following line in `/etc/sysctl.conf` to enable IPv4 forwarding:

```sh
net.ipv4.ip_forward=1
```
## Introduction

NFTables is the replacement for IPTables for packet filtering on Linux machines.  Going forward IPTables will likely be implemented using NFTables on Linux machines.  It is a significant improvement in terms of rule readability, however, there is a learning curve for the new syntax.

The best source of information for understanding NFTables is the [nftables Wiki](https://wiki.nftables.org/wiki-nftables/index.php/Main_Page)

Ensure you are running the latest version of `nftables` with `apt update; apt install nftables`.
## Rulesets, Chains, Expressions and Hooks

NF tables functions similarly in that you create chains containing rules. Each chain is hooked into a specific phase in the Linux net filtering pipeline.  There are two types of chains, base-chains and sub-chains.  A base-chain is tied into a network hook (see the above diagram).  Base-chains have a priority (low to high) to help when there are multiple chains attached to a hook.   Sub-chains are called from base-chains to handle specific special cases.  Chains consist of a sequence of rules.

See the following diagram for better understanding of the different base chain hook points:

![[netfilter-hooks.png]]


Note that bridge interfaces have their own set of hooks.  Packets may traverse up to the IP layer from bridge interfaces, or they may pass through.  Bridge packets only go up to the IP layer when they need to be handled by a local process or passed to a physical network interface to leave the machine.

Persistent NFTables configuration lives in `/etc/nftables.conf` and in reloaded by the `nftables.service` which must be enabled and started the first time using `systemctl`.

NFTables handles both IPv4 and IPv6 using one set of tools and rulesets.

## Migration

The NFTables command line tool is call `nft` which replaces `iptables` and all related programs.

To migrate IPTablesto NFTables use the tool `iptables-restore-translate` and `ip6tables-restore-translate`.

See [Moving from iptables to nftables](https://wiki.nftables.org/wiki-nftables/index.php/Moving_from_iptables_to_nftables) for more information.

If you are using `fail2ban` then you need to change all instances of `iptables` to `nftables` in the Fail2ban configuration files under `/etc/fail2ban`.  Stop `fail2ban` before you do that and restart it afterward.

Flush `iptables -F`, remove any persistence mechanisms, then remove `iptables` with `sudo apt remove iptables`

## Adding Temporary Rules

Allow port 80 connections temporarily:

```sh
sudo nft insert rule inet firewall inbound tcp dport 80 counter accept comment \"Temporarily allow HTTP\"
sudo nft insert rule inet firewall inbound tcp dport 443 counter accept comment \"Temporarily allow HTTPS\"
```

Then use `nft -a list ...` to find the handle(s) of the rule ($HANDLE) and remove with one or more commands:

```sh
sudo nft delete rule inet firewall inbound handle $HANDLE
```

## Temporarily Disable

```
sudo systemctl stop nftables

```
## Debugging

To see the NFTables and the ruleset for a table:

```sh
sudo nft list tables # Shows all tables
sudo nft list table global # Assuming a table called `global`
sudo nft list chains # List all chains
sudo nft list tables # List all tables
sudo nft -a list chain inet firewall inbound # List table `inet firewall` with `inbound` chain with handles
```

To avoid problems with bad tables, run the following to check them for errors before loading:

```
nft -f /etc/nftables.conf -c
```

Then:

1. Run `tmux`
2. **Ctrl+B %** to split the shell
3. Type `sleep 120; and sudo nft flush ruleset`
4. **Ctrl+B ◀** to go back to first shell
5. `systemctl restart nftables`
 
If there are problems the second shell will reset the rules. If not kill the `sleep` with `ps -ax | grep sleep`.

## References

- [nft man page](https://www.mankier.com/8/nft)