## Summary

Install the Go programming language tools.
## Installation

### Linux

```fish
#!/usr/bin/fish

set -l GOLANG "$(curl -s https://go.dev/dl/ | awk -F[\>\<] '/linux-arm64/ && !/beta/ {print $5;exit}')"
wget https://golang.org/dl/$GOLANG
sudo rm -r /usr/local/go
sudo tar -C /usr/local -xzf $GOLANG
rm $GOLANG
```

### macOS

```fish
brew install go
```

## Configuration

Add to your `~/.config/fish/config.fish` file:

```fish
fish_add_path /usr/local/go/bin
fish_add_path -P $HOME/go/bin
```

## References

- [The Go Programming Language](https://go.dev)