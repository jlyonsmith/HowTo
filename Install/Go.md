# Install Go

## Ubuntu Instructions

```bash
cd ~
curl -O https://dl.google.com/go/go1.12.4.linux-amd64.tar.gz
tar xvf go1.12.4.linux-amd64.tar.gz
sudo chown -R root:root ./go
sudo mv ./go /usr/local
```

Then add to `.bashrc`:

```bash
export GOPATH=$HOME/go
export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin
```

## macOS Instructions

```bash
brew install go
```

And add a `GOPATH` environment variable in `.bashrc`:

```bash
export GOPATH=$HOME/go
```
