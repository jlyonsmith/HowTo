## Configuration

You may need the nightly build:

```bash
rustup install nightly
rustup default nightly

```

Then install Rust's native LLVM based code coverage tools:

```bash
rustup component add llvm-tools-preview
cargo install grcov
```

The run `./get-coverage.sh` to generate a `.profraw` file in the `/scratch` directory, and HTML coverage report. Open it with `open ./target/debug/coverage/*.html`.
