## Overview

**Rhai** is a tiny, fast, and safe embedded scripting language designed specifically for the **Rust programming language**. It acts as a dynamic control layer over Rust applications, allowing you to easily add scriptable behavior, game logic, or custom configurations without writing and compiling new Rust code. [
### Key Features

- **Familiar Syntax:** Combines the best of both JavaScript and Rust, using dynamic typing.
- **Tight Rust Integration:** Seamlessly works with native Rust functions, types, getters, and setters. You can freely pass almost any clonable Rust value into a script.
- **Performant:** Evaluates quickly (e.g., executing one million iterations in around 0.14 seconds) using an AST-walking engine.
- **Highly Portable:** Builds for most CPU architectures, supports `no-std`, and compiles easily to **WebAssembly (WASM)**.
- **No Bloat:** Deliberately avoids heavy language features like classes, inheritance, and async programming to keep things lean and fast. 

### Typical Use Cases

- **Configuration:** Exposing an external script file (e.g., `config.rhai`) so users can tweak game rules, UI behaviors, or application settings without recompiling.
- **Game Modding:** Allowing players or designers to script game events and entity behaviors in a sandbox environment.
- **API Customization:** Used in production tools like the [Apollo Router](https://www.apollographql.com/docs/graphos/routing/customization/rhai/reference) to allow developers to customize network routing lifecycles. 

### How it Works (Quick Example)

In a Rust project, executing a Rhai script takes just a few lines of code:

```rust
use rhai::{Engine, EvalAltResult};

fn main() -> Result<(), Box<EvalAltResult>> {
    let engine = Engine::new();
    
    // Evaluate a string script directly
    let result = engine.eval::<i64>("40 + 2")?;
    
    println!("Answer: {}", result); // Answer: 44
    Ok(())
}
```

## Custom Modules

Building a custom library (or module) in Rhai can be done in one of two ways: ==writing it directly as a **Rhai script**== or writing it in **Rust** for ultimate performance. [[1](https://rhai.rs/book/language/modules/index.html), [2](https://rhai.rs/book/rust/modules/create.html)]

Method 1: The Script-Only Way (Pure Rhai)

Rhai allows you to organize logic into separate `.rhai` files. Other scripts can then import and use your library. [[1](https://rhai.rs/book/language/modules/index.html), [2](https://blog.logrocket.com/building-game-rust-rhai/)]

1. **Create your library file** (`my_lib.rhai`):
    
    javascript
    
    ```
    // Define a function
    export fn add_tax(price, tax_rate) {
        return price + (price * tax_rate);
    }
    
    // Define a constant variable
    export const VERSION = "1.0.0";
    ```
    
    Use code with caution.
    
2. **Use it in a main script** (`main.rhai`):
    
    javascript
    
    ```
    // Import the file as a module named 'math'
    import "my_lib" as math;
    
    print(math::VERSION);
    let total = math::add_tax(100.0, 0.08);
    ```
    
    Use code with caution.
    
    [[1](https://rhai.rs/book/rust/modules/resolvers/custom.html), [2](https://rhai.rs/book/rust/packages/crate.html), [3](https://rhai.rs/book/rust/modules/index.html), [4](https://rhai.rs/book/rust/packages/index.html), [5](https://blog.logrocket.com/building-game-rust-rhai/)]

Method 2: The Native Way (Rust Plugins)

Because Rhai is designed to embed into Rust, you can write powerful, native functions and group them into a library. Rhai’s **`#[export_module]`** macro makes this seamless. [[1](https://rhai.rs/book/plugins/index.html), [2](https://rhai.rs/), [3](https://www.reddit.com/r/rust/comments/1n15s9y/good_scripting_language_embeddable_in_rust/), [4](https://rhai.rs/book/rust/packages/index.html), [5](https://blog.logrocket.com/building-game-rust-rhai/)]

1. **Add Rhai to your Rust crate** (`Cargo.toml`):
    
    toml
    
    ```
    [dependencies]
    rhai = "1.25"
    ```
    
    Use code with caution.
    
2. **Define the module** in your Rust code (`src/lib.rs`):
    
    rust
    
    ```
    use rhai::plugin::*;
    
    // Export this Rust module to Rhai
    #[export_module]
    pub mod my_math_lib {
        // Function accessible to Rhai
        pub fn add(a: i64, b: i64) -> i64 {
            a + b
        }
    
        // A constant
        pub const PI: f64 = 3.14159;
    }
    ```
    
    Use code with caution.
    
3. **Register the module** in your Rust engine:
    
    rust
    
    ```
    use rhai::{Engine, exported_module};
    
    fn main() {
        let mut engine = Engine::new();
    
        // Convert the Rust module to a Rhai module
        let module = exported_module!(my_math_lib);
    
        // Register it into the global namespace
        engine.register_global_module(module.into());
    
        // Now you can run scripts that use `add()` and `PI` directly!
    }
    ```

## Custom Data Types

Building native data structures in Rhai means ==creating custom types in Rust and exposing them to the Rhai scripting engine==. [[1](https://rhai.rs/book/rust/custom-types.html)]

To do this:

1. Define your struct in Rust and derive `Clone`.
2. Register the type using `Engine::register_type`.
3. Expose methods and properties using `register_fn` or **Plugin Modules**. [[1](https://rhai.rs/book/rust/reg-custom-type.html), [2](https://rhai.rs/book/rust/build-type.html)]

Here is how you can expose a custom Rust struct to Rhai:

1. Define the Struct and Methods

In your Rust code, define your custom data structure and its associated methods (like constructors and getters/setters). [[1](https://rhai.rs/book/rust/custom-types.html), [2](https://www.youtube.com/watch?v=3Ly25IYHIMc), [3](https://rhai.rs/book/engine/custom-syntax.html)]

```rust
use rhai::{Engine, EvalAltResult};

// 1. Define your custom struct
#[derive(Clone, Debug)]
pub struct InventoryItem {
    pub name: String,
    pub quantity: i64,
}

// 2. Implement an API
impl InventoryItem {
    pub fn new(name: String, quantity: i64) -> Self {
        Self { name, quantity }
    }

    pub fn get_name(&mut self) -> String {
        self.name.clone()
    }

    pub fn add_stock(&mut self, amount: i64) {
        self.quantity += amount;
    }
}
```

2. Register with the Rhai Engine

Use the `Engine` to register your type and functions so Rhai scripts understand how to use them. [[1](https://rhai.rs/book/rust/reg-custom-type.html)]

```rust
fn main() -> Result<(), Box<EvalAltResult>> {
    let mut engine = Engine::new();

    // 3. Register the type
    engine.register_type::<InventoryItem>()
          .register_type_with_name::<InventoryItem>("InventoryItem") // Name shown in scripts
          .register_fn("new_item", InventoryItem::new)
          .register_fn("get_name", InventoryItem::get_name)
          .register_fn("add_stock", InventoryItem::add_stock);

    // Now, your script can natively interact with InventoryItem
    let result = engine.eval::<i64>(r#"
        let item = new_item("Sword", 5);
        item.add_stock(10);
        item.get_name(); // Returns "Sword"
    "#)?;

    println!("Script result: {}", result);
    Ok(())
}
```

### Alternative: Exposing Complex Collection Types

Rhai has built-in support for array-like structures (`rhai::Array` which is a `Vec<dyn Variant>`) and object maps. If you are building a custom data structure like a map or an array, it is usually much faster and easier to expose a Rust collection and let Rhai treat it as a native collection rather than registering a complex custom object from scratch. [[1](https://rhai.rs/book/patterns/oop.html), [2](https://rhai.rs/book/language/arrays.html), [3](https://rhai.rs/book/rust/collections.html)]
## References

- [Rhai - Embedded Scripting for Rust](https://rhai.rs)
- [The Rhai Book - Rhai - Embedded Scripting for Rust](https://rhai.rs/book)
- [A Survey of Rust Embeddable Scripting Languages | boringcactus](https://www.boringcactus.com/2020/09/16/survey-of-rust-embeddable-scripting-languages.html)