# Installing the Rust Code Coverage Tools

To install Rust's native LLVM based code coverage tools:

```zsh
rustup install nightly
rustup default nightly
rustup component add llvm-tools-preview
cargo install grcov
```

The run `./get-coverage.sh` to generate a `.profraw` file in the `/scratch` directory, and HTML coverage report. Open it with `open ./target/debug/coverage/*.html`.
