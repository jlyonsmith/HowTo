# Install Rust

On Linux you need to install Rust tools separately from each user, including `root`.

## Debian


```sh
apt update -y
apt install build-essentials
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

Assuming the `fish` shell `fish_app_path /root/.cargo/bin`.
