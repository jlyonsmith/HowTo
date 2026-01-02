## Overview

Python 3 has replaced Python 2 everywhere.  Python 3 now pretty much requires that all Python programs run in a virtual environment that locks down the Python version and libraries for that program.

`pyenv` is a tool for managing Python versions and in particular the global Python installations.  It has a plug-in called `pyenv-virtualenv` that enables you to seamlessly switch between ("activate" in Python lingo) virtual environments.

## Installation

```sh
brew install pyenv pyenv-virtualenv
```

Ensure that `pyenv` installed with by adding to your `~/.config/fish/config.fish`:

```fish
# Python
if which pyenv >/dev/null
	pyenv init - fish | source
end
```

## Use

Create a new Python virtual environment with:

```sh
pyenv virtualenv 3.11.14 chatterbox
```

This one is called `chatterbox` for example.  Then activate it with:

```fish
pyenv activate chatterbox
```