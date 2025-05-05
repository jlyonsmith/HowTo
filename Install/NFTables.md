
## Introduction

NFTables is the replacement for IPTables for packet filtering on Linux machines.  Going forward IPTables will likely be implemented using NFTables on Linux machines.  It is a significant improvement in terms of rule readability, however, there is a learning curve for the new syntax.

The best source of information for understanding NFTables is the [nftables Wiki](https://wiki.nftables.org/wiki-nftables/index.php/Main_Page)

Ensure you are running the latest version of `nftables` with `apt update; apt install nftables`.
## Rulesets, Chains, Expressions and Hooks

NF tables functions similarly in that you create chains containing rules. Each chain is hooked into a specific phase in the Linux net filtering pipeline. See the following diagram for better understanding:

![[netfilter-hooks.png]]

There are two types of chains, base chains and regular chains.  A base chain is tied into a network hook (see the above diagram).  Base chains have a priority (low to high) to help when there are multiple chains attached to a hook.

Note that bridge interfaces have their own set of hooks.  Packets may traverse up to the IP layer from bridge interfaces, or they may pass through.  Bridge packets only go up to the IP layer when they need to be handled by a local process or passed to a physical network interface to leave the machine.

Persistent NFTables configuration lives in `/etc/nftables.conf` and in reloaded by the `nftables.service` which must be enabled and started the first time using `systemctl`.

NFTables handles both IPv4 and IPv6 using one set of tools and rulesets.

## Migration

The NFTables command line tool is call `nft` which replaces `iptables` and all related programs.

To migrate IPTablesto NFTables use the tool `iptables-restore-translate` and `ip6tables-restore-translate`.

See [Moving from iptables to nftables](https://wiki.nftables.org/wiki-nftables/index.php/Moving_from_iptables_to_nftables) for more information.

If you are using `fail2ban` then you need to change all instances of `iptables` to `nftables` in the Fail2ban configuration files under `/etc/fail2ban`.  Stop `fail2ban` before you do that and restart it afterward.

Flush `iptables -F`, remove any persistence mechanisms, then remove `iptables` with `sudo apt remove iptables`
## Debugging

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