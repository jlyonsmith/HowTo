## Overview

Using [flutter_rust_bridge](https://www.google.com/search?client=firefox-b-1-d&q=flutter_rust_bridge&ved=2ahUKEwjX-NnfqraTAxXGITQIHUAYG4kQgK4QegQIARAB) (FRB) to wrap Rust crates allows you to expose Rust functions, structs, and methods to Flutter/Dart, bridging high-performance Rust logic with a cross-platform UI. It automatically generates FFI code, manages memory, and supports async calls, requiring only a defined Rust API file (`api.rs`). 

Key Steps to Wrap Rust Crates with FRB

**1. Setup and Dependencies**

- Create a Rust library (`cargo new --lib native`) inside your Flutter project folder.
- Add `flutter_rust_bridge` to your Rust `Cargo.toml` dependencies.
- Configure the `Cargo.toml` to output `cdylib` and `staticlib` for cross-platform support.
- Install the `flutter_rust_bridge_codegen` CLI tool to generate glue code. 

**2. Creating the Wrapper (The "Bridge")**

- **Create `api.rs`:** In your Rust source code (`native/src/api.rs`), write public functions or structs that wrap the target crate's functionality.
- **Import External Crate:** Inside `api.rs`, import the crate you want to wrap.
- **Define Bridge Structure:** Use Rust structures that are compatible with FRB. If the third-party crate is hard to bridge, use wrapper structs.
- **Use `#[frb(ignore)]`:** If some third-party types cannot be automatically translated, you can ignore them and create tailored methods, says [the Tricks page of the flutter_rust_bridge guide](https://cjycode.com/flutter_rust_bridge/guides/third-party/automatic/tricks). 

**3. Generate Glue Code**

- Run the codegen tool in your terminal. This parses your `api.rs` and generates `bridge_generated.dart` and corresponding FFI C headers.
- `flutter_rust_bridge_codegen -r native/src/api.rs -d lib/bridge_generated.dart ...`. 

**4. Use in Flutter** 

- Load the generated Dart code and call the Rust functions directly as if they were native Dart async methods. 

## Example Wrapper Approach

If you want to use a crate named `example_lib`, you can do:

```rust
// native/src/api.rs
use example_lib::SomeStruct;

pub struct WrappedStruct {
    inner: SomeStruct,
}

pub fn create_wrapped_struct() -> WrappedStruct {
    WrappedStruct { inner: SomeStruct::new() }
}
```

Then, run `codegen`, and this `WrappedStruct` will be available in Flutter.