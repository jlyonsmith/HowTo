# Installation

Rust installation involves first installing the `rustup` tool which bootstraps and manages the Rust toolchain.
### Linux and macOS

```fish
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

## Configuration

Add to `~/.config/fish/config.fish`:

```fish
# Cargo/Rust
fish_add_path -P "$HOME/.cargo/bin"
if not test -e $FISH_COMPLETIONS/cargo.fish
    curl -s https://raw.githubusercontent.com/fish-shell/fish-shell/master/share/completions/cargo.fish -o $FISH_COMPLETIONS/cargo.fish
end
```

This will add Rust tooling to the `PATH` and shell completions for the Fish shell.