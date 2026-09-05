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
colima ssh -p $PROFILE
```

Without the `-p` you will access the `default` instance profile.

## Setting Up Rust on Instance

SSH to the instance, then:

```sh
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

Then each time:

```sh
. "$HOME/.cargo/env"
sudo apt update
sudo apt install build-essential pkg-config
# Install any other needed libraries for your project...
```

## Install Docker BuildX

```sh
brew install docker-buildx
```

Then edit `~/.docker/config.json` and add:

```json
{
  ...
  "cliPluginsExtraDirs": [
    "/opt/homebrew/lib/docker/cli-plugins"
  ]
}
```

Then run `docker buildx` to test.

Also, you may need to remove the Docker Desktop credential store from the `~/.docker/config.json` file.  Remove the line starting with `"credsStore":...`.
## Rust Dev Container Images

The Microsoft Artifact Registry contains fully configured [Rust Development Container Images](https://mcr.microsoft.com/en-us/artifact/mar/devcontainers/rust) which you can use in your `Docker`

## DevContainer Builds

DevContainers is Microsofts extensions to VSCode that allow you to build within Docker containers from inside VSCode.  It's also supported by the Zed editor.  It's important to understand that Docker has two phases: build and run.  With a `Dockerfile` and `devcontainer.json` file defined in the `.devcontainer` directory, you can run build on the command line with:

```sh
devcontainer up --workspace-folder .
devcontainer exec --workspace-folder . cargo build --target aarch64-unknown-linux-gnu --package my-app --release
```

You don't need to stop the instance, but if you want to:

```bash
docker ps # Find the instance name
docker stop $INSTANCE_NAME
```

Run a `bash` shell in the DevContainer docker instance:

```bash
devcontainer exec --workspace-folder . bash
# You can also use the plain old docker CLI ...
```

To rebuild a DevContainer after any `.devcontainer` change, you need to do:

```bash
devcontainer up --workspace-folder . --remove-existing-container
```

You can set environment variables in the DevContainer with:

```bash
devcontainer exec --remote-env RUSTFLAGS=... 
```
## Uninstall Colima

```sh
colima stop
colima delete
brew uninstall colima
```