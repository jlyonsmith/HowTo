## Installation

```sh
# Install Just (from binary)
wget https://github.com/casey/just/releases/download/1.40.0/just-1.40.0-aarch64-unknown-linux-musl.tar.gz
mkdir just
tar -xvf just-1.40.0-aarch64-unknown-linux-musl.tar.gz -C just
sudo mv just/just /usr/local/bin
rm -rf just-1.40.0-aarch64-unknown-linux-musl.tar.gz
mv just/completions/just.fish ~/.config/fish/completions/just.fish
rm -rf just/
```