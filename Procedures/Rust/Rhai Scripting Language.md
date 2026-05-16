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

## References

- [Rhai - Embedded Scripting for Rust](https://rhai.rs)
- [The Rhai Book - Rhai - Embedded Scripting for Rust](https://rhai.rs/book)
- [A Survey of Rust Embeddable Scripting Languages | boringcactus](https://www.boringcactus.com/2020/09/16/survey-of-rust-embeddable-scripting-languages.html)