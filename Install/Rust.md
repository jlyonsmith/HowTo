## Installation

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

The native linker on most platforms is slow.  The `lld` linker which is part of LLVM is faster.  Install it on macOS with `homebrew install lld` and on Linux with `apt install lld`.

You can get Rust to use it by doing:

```sh
RUSTFLAGS="-Clinker-args=-fuse-ld=lld" cargo build
```

Or by adding a `.cargo/config.toml` file with:

```toml
[build]
rustflags = ["-Clink-args=-fuse-ld=lld"]
```

## Modules

Remember this about modules:
```rust
// src/lib.rs
mod foo {
    fn test() {}
}
```
Is exactly the same as this:
```rust
// src/lib.rs
mod foo;

// src/foo.rs
fn test() {}
```
Which is exactly the same as this:
```rust
// src/lib.rs
mod foo;

//src/foo/mod.rs
fn test() {}
```

and this can be repeated down the directory tree.  It's easiest to use `include!` to avoid making new modules.
## Books

- [Rust Standard Library](https://doc.rust-lang.org/std/index.html)
- [Rust Book](https://play.rust-lang.org/)
- [Rust Reference](https://doc.rust-lang.org/stable/reference/index.html)
- [Cargo Book](https://doc.rust-lang.org/cargo/index.html)
- [Rust by Example](https://doc.rust-lang.org/rust-by-example/index.html)
- [Rust Edition Guide 2018](https://doc.rust-lang.org/nightly/edition-guide/introduction.html)
- [The Little Book of Rust Macros](https://veykril.github.io/tlborm/macros/macro_rules.html)
- [Half an Hour to Learn Rust](https://fasterthanli.me/articles/a-half-hour-to-learn-rust)
- [Rust Unstable Book](https://doc.rust-lang.org/nightly/unstable-book/the-unstable-book.html)

## Articles

- [Arrays, References and Slices in Rust](https://hashrust.com/blog/arrays-vectors-and-slices-in-rust/)
- [Where to Put the Turbofish](https://matematikaadit.github.io/posts/rust-turbofish.html)

## Cheat Sheet

- [Rust Language Cheat Sheet](https://cheats.rs/)

## Associated Types

Use associated type when there is a one-to-one relationship between the type implementing the trait and that type.  It's referred to as an *output type* because it's the output of applying a trait to the parent type.

- [Associated Types](https://riptutorial.com/rust/example/8574/associated-types)

## Tools

- [Rust Playground](https://play.rust-lang.org/)
- [GCC/LLVM Code Coverage](https://doc.rust-lang.org/nightly/unstable-book/compiler-flags/source-based-code-coverage.html)
- [Tarpaulin Code Coverage Tool](https://github.com/xd009642/tarpaulin)
- [Moves, copies and clones in Rust](https://hashrust.com/blog/moves-copies-and-clones-in-rust/)
- `rustup component add rust-doc` then `rustup doc` for offline documentation

## Programming

### I/O

Standard out, `io::stdout()` and standard in, `io::stdin()`.

Read a line to a string `io::stdin().read_to_string(&mut input)?;`.  `std::io::Read` trait must be in scope.

Write a line to a file `writeln!(io::stdio(), "{}", line)`.  `std::io::Write` trait must be in scope.

[Different ways of reading a file](https://dev.to/dandyvica/different-ways-of-reading-files-in-rust-2n30).

[Serializing with Serde](https://serde.rs/).  [Deserializing JSON](https://juliano-alves.com/2020/01/06/rust-deserialize-json-with-serde/)

### String

Use `for line in input.lines() { }` to iterate all lines of a string.

Use `let value: i32 = line.parse()?;` to parse an integer.  Type of `value` implicitly defines `parse` method used.

See if a string is ASCII - `line.is_ascii()`

Get an iterator for the characters of a string - `str1.chars()`

### Errors

Declare `type Result<T> = ::std::result::Result<T, Box<dyn ::std::error::Error>>;` to save typing.

### Collections

Bring in scope`use std::collections::HashSet;`. Use `insert(T)` to add.  Use `contains(&T)` to test.

### Arrays

Get array length - `arr.len()`.

Arrays must be indexed by `usize`.

### Iteration

To get a mutable iterator - `for f in list.iter_mut()`

Zip entries from two iterators together - `iter1.zip(iter2)`

Filter items from an iterator - `iter1.filter(|&item| item != 0)`

### Useful Crates

- [lazy_static](https://docs.rs/lazy_static/1.1.1/lazy_static/)
- [regex](https://docs.rs/regex/1.4.2/regex/index.html)

## Cross Compile x86_64 on AArch64

To cross-compile a Rust project from AArch64 Linux (like a Raspberry Pi or an Apple Silicon Mac running Linux in a VM) to x86_64 Linux, you need to follow these steps:

1. **Install the necessary target and linker.**
2. **Configure your Rust project for cross-compilation.**
3. **Build the project.** 

Here is a detailed guide:

### Prerequisites

You need a Rust toolchain installed, typically managed via `rustup`. 

#### Step 1: Install the x86_64 Linux Target 

You need to tell `rustup` that you intend to build for the `x86_64-unknown-linux-gnu` target. 

bash

```
rustup target add x86_64-unknown-linux-gnu
```

#### Step 2: Install the Cross-Compilation Toolchain (Linker) 

Building code for a different architecture requires a _cross-compiler_ or _linker_ for that specific target. The exact command depends on your AArch64 Linux distribution: 

For Debian/Ubuntu-based systems (e.g., Raspberry Pi OS):

bash

```
sudo apt update
sudo apt install gcc-x86-64-linux-gnu binutils-x86-64-linux-gnu
```

For Arch Linux ARM:

bash

```
sudo pacman -S x86_64-linux-gnu-gcc
```

#### Step 3: Configure Your Rust Project 

Rust needs to know which linker to use when compiling for the target architecture. You can do this globally or per-project. 

Per-Project Configuration (Recommended)

Navigate to the root directory of your Rust project and create a `.cargo` directory if it doesn't exist. Inside `.cargo`, create a file named `config.toml`: 

bash

```
mkdir -p .cargo
nano .cargo/config.toml
```

Add the following configuration to `config.toml`, which tells Rust to use the newly installed `gcc-x86-64-linux-gnu` as the linker for the `x86_64-unknown-linux-gnu` target:

toml

```
[target.x86_64-unknown-linux-gnu]
linker = "x86_64-linux-gnu-gcc"
```

#### Step 4: Build Your Project

Now you can build your Rust project specifically for the x86_64 target using the `--target` flag:

bash

```
cargo build --target=x86_64-unknown-linux-gnu
# or for a release build:
cargo build --release --target=x86_64-unknown-linux-gnu
```

The resulting executable file will be located in the `target/x86_64-unknown-linux-gnu/debug/` or `target/x86_64-unknown-linux-gnu/release/` directory. This binary can be run on any x86_64 Linux system.