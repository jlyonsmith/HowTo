## Summary

Duplicity is a backup tool used by Mail-in-a-Box.

## Installation

```sh
sudo apt-get update 
sudo apt-get install -y \
        build-essential \
        intltool \
        lftp \
        librsync-dev \
        libffi-dev \
        libssl-dev \
        openssl \
        par2 \
        python3-dev \
        python3-pip \
        python3-venv \
        python3 \
        rclone \
        rsync \
        rdiff \
        tzdata
sudo python3 -m pip install --upgrade pip pipx
which -a duplicity # should return nothing; if not uninstall with `apt remove`
sudo -Es
export PIPX_GLOBAL_BIN_DIR=/usr/local/bin
export PIPX_BIN_DIR=/usr/local/bin
export PIPX_HOME=/opt/pipx
pipx install --global duplicity
pipx --global ensurepath
exit
```
## References

- [Duplicity on GitLab](https://gitlab.com/duplicity/duplicity)