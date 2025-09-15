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

### Code Coverage

Install Rust's native LLVM based code coverage tools:

```bash
rustup component add llvm-tools
cargo install grcov
```

The run `./get-coverage.sh` to generate a `.profraw` file in the `/scratch` directory, and HTML coverage report. Open it with `open ./target/debug/coverage/*.html`.

## Linking

The native linker on most platforms is really slow.  The `lld` linker which is part of LLVM is faster.  Install it on macOS with `homebrew install lld` and on Linux with `apt install lld`.

You can get Rust to use it by doing:

```sh
RUSTFLAGS="-Clinker-args=-fuse-ld=lld" cargo build
```

Or by adding a `.cargo/config.toml` file with:

```toml
[build]
rustflags = ["-Clink-args=-fuse-ld=lld"]
```