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
colima start x86_64 --arch x86_64 --vz-rosetta --ssh-port 2222
```

## Accessing

You can access the instances individually by name using, for example:

```sh
colima ssh -p aarch64 
```

Without the `-p` you will access the `default` instance profile.