# Set Timezone on Ubuntu

Run:

```sh
timezonectl list-timezones
```

Find the timezone you want from the list, then:

```sh
sudo timezonectl set-timezone America/Los_Angeles
```

To test:

```sh
timezonectl
date
```

## References

[How To Set or Change Timezone on Ubuntu 20.04](https://linuxize.com/post/how-to-set-or-change-timezone-on-ubuntu-20-04/)