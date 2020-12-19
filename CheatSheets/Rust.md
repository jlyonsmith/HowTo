# Rust Cheat Sheet

## Books

[Rust Standard Library](https://doc.rust-lang.org/std/index.html)
[Rust Book](https://play.rust-lang.org/)
[Rust Reference](https://doc.rust-lang.org/stable/reference/index.html)
[Cargo Book](https://doc.rust-lang.org/cargo/index.html)
[Rust by Example](https://doc.rust-lang.org/rust-by-example/index.html)
[Rust Edition Guide 2018](https://doc.rust-lang.org/nightly/edition-guide/introduction.html)
[The Little Book of Rust Macros](https://veykril.github.io/tlborm/macros/macro_rules.html)

## Articles

[Arrays, References and Slices in Rust](https://hashrust.com/blog/arrays-vectors-and-slices-in-rust/)
[Where to Put the Turbofish](https://matematikaadit.github.io/posts/rust-turbofish.html)

## Associated Types

Use associated type when there is a one-to-one relationship between the type implementing the trait and that type.  It's referred to as an *output type* because it's the output of applying a trait to the parent type.

- [Associated Types](https://riptutorial.com/rust/example/8574/associated-types)

## Tools

[Rust Playground](https://play.rust-lang.org/)
[Tarpaulin Code Coverage Tool](https://github.com/xd009642/tarpaulin)

## Programming

### I/O

Standard out, `io::stdout()` and standard in, `io::stdin()`.

Read a line to a string `io::stdin().read_to_string(&mut input)?;`.  `std::io::Read` trait must be in scope.

Write a line to a file `writeln!(io::stdio(), "{}", line)`.  `std::io::Write` trait must be in scope.

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
