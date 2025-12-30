## Overview

[Colima](https://github.com/abiosoft/colima) is a command line interface for managing [Lima](https://github.com/lima-vm/lima) virtual machines.  It's faster than Docker Desktop and doesn't have all the licensing issues that Docker Desktop has.

## Installation

To install on macOS:

```
brew install colima
```

To add `x86_64` support on Apple silicon you need to install Rosetta and [QEMU](https://www.qemu.org/):

```sh
brew install lima-additional-guestagents qemu
softwareupdate --install-rosetta
```

## Creating VM Instances

To create an `aarch64` VM:

```sh
colima start aarch64 --arch aarch64 --ssh-port 2223
```

To create an `x86_64` VM:

```sh
colima start x86 --arch x86_64 --vz-rosetta --ssh-port 2222
```

## Accessing

You can access the instances individually by name using, for example:

```sh
colima ssh -p aarch64 
```

Without the `-p` you will access the `default` instance profile.

## Setting Up Rust on Instance

```sh
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

Then each time:

```sh
. "$HOME/.cargo/env"
sudo apt update
sudo apt install build-essential pkg-config
# Install any other needed libraries for your project, then...
CARGO_TARGET_DIR="./target/$(rustc --print host-tuple)/" cargo build
```

## Cross Compile `x86_64` on `aarch64` Linux

To cross-compile a Rust project from AArch64 Linux (like a Raspberry Pi or an Apple Silicon Mac running Linux in a VM) to x86_64 Linux, you need to follow these steps:

1. **Install the necessary target and linker.**
2. **Configure your Rust project for cross-compilation.**
3. **Build the project.** 
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