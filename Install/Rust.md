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

