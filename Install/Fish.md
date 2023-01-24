# Install & Use the Fish Shell

An easy to learn and use shell that sacrifices a some POSIX compliance for consistency & simplicity, without sacrificing functionality. See the [Fish command shell site](https://fishshell.com/) for all the details.  *Yes, they probably should update the headline.  It is a little out-of-date.* You can also look at the [source code on GitHub](https://github.com/fish-shell/fish-shell).

## Install

On macOS `brew install fish`.

On Ubuntu:

```sh
sudo apt-add-repository ppa:fish-shell/release-3
sudo apt update
sudo apt install fish
```

## Documentation

All the documentation you need is at [fishshell.com](https://fishshell.com/).

## Config

The default configuration file is `~/.config/fish/config.fish` which is created the first time you run `fish`.

There is no separate interactive vs. non-interactive configuration as with `bash`. Just use the `is-interactive` built-in to check if the shell is being used interactively.

### Basic Configuration

Install [Starship](https://starship.rs/).  Configure `~/.config/starship.toml` with:

```toml
# Don't print a new line at the start of the prompt
add_newline = false

[container]
disabled=true
```

Start `fish` once, then `exit` and edit `~/.config/fish/config.fish` with:

```fish
if status is-interactive
  # Commands to run in interactive sessions can go here
  set FISH_COMPLETIONS "$HOME/.config/fish/completions"

  # Set the terminal title to the basename of the directory
  function fish_title
      echo (basename (pwd))
  end

  # Set tab color e.g. tab-color -r255 -g0 -b0
  function tab-color
      argparse r/red= g/green= b/blue= -- $argv
      or return
      printf '\x1b]6;1;bg;red;brightness;%s\x7' $_flag_r
      printf '\x1b]6;1;bg;green;brightness;%s\x7' $_flag_g
      printf '\x1b]6;1;bg;blue;brightness;%s\x7' $_flag_b
  end
end

set -gx EDITOR 'vim'

# Aliases
alias egrep 'egrep --color=auto'
alias fgrep 'fgrep --color=auto'
alias grep 'grep --color=auto'
alias l 'ls -CF'
alias la 'ls -A'
alias ll 'ls -al'
alias ls 'ls --color=auto'
alias edit "vi"
alias bn "babel-node"
alias ipts "iptables-save"
alias iptn "iptables -t nat"
alias iptf "iptables -t filter"
alias iptr "iptables -t raw"
alias sc "systemctl"
alias jc "journalctl"

starship init fish | source
```

### Examples

```fish
# Set completions directory
set FISH_COMPLETIONS ~/.config/fish/completions
```

```fish
# Local bin
fish_add_path "$HOME/bin"
```

```fish
# Set tab color e.g. tab-color -r255 -g0 -b0
function tab-color
    argparse r/red= g/green= b/blue= -- $argv
    or return
    printf '\x1b]6;1;bg;red;brightness;%s\x7' $_flag_r
    printf '\x1b]6;1;bg;green;brightness;%s\x7' $_flag_g
    printf '\x1b]6;1;bg;blue;brightness;%s\x7' $_flag_b
end
```

```fish
# Set the terminal title to the basename of the directory
function fish_title
    echo (basename (pwd))
end
```

```fish
# Java
if test -e /usr/libexec/java_home
    set -gx JAVA_HOME (/usr/libexec/java_home)
end
```

```fish
# Cargo/Rust
fish_add_path "~/.cargo/bin"
if not test -e $FISH_COMPLETIONS/cargo.fish
    curl -s https://raw.githubusercontent.com/fish-shell/fish-shell/master/share/completions/cargo.fish -o $FISH_COMPLETIONS/cargo.fish
end
```

```fish
# nodenv
if which nodenv >/dev/null
    fish_add_path -p "~/.nodenv/shims"
    nodenv rehash
    if not test -e $FISH_COMPLETIONS/nodenv.fish
        curl -s https://raw.githubusercontent.com/nodenv/nodenv/master/completions/nodenv.fish -o $FISH_COMPLETIONS/nodenv.fish
    end
end
```

```fish
# rbenv
if which rbenv >/dev/null
    fish_add_path -p "~/.rbenv/shims"
    rbenv rehash
    if not test -e $FISH_COMPLETIONS/rbenv.fish
        curl -s https://github.com/rbenv/fish-rbenv/blob/master/completions/rbenv.fish -o $FISH_COMPLETIONS/rbenv.fish
    end
    set -gx RUBY_CONFIGURE_OPTS "--with-openssl-dir="(brew --prefix openssl@1.1)
end
```

```fish
# Starship
if status is-interactive
    starship init fish | source
end
```

## Change Default Shell

Ensure the `/etc/shells` file has `(/usr/local/bin/fish)` (or whatever `which fish` shows on your system) as a valid option. Set `fish` default shell with:

```sh
sudo chsh -s $(which fish) $USER
```

## Use the Hashbang

Ensure your scripts start with `#!/usr/bin/env <shell>` to ensure that they run with the correct shell.

## Visual Studio Code

Do **⌘ ⇧ P** then type `Terminal: Select Default Profile` and select `fish`.  The use **⌃ `** to open a new Terminal and test.

## Configure Completions

There are lots of completions for Fish.  Just Google them and then use the `test -e` and `curl` trick show in the examples to download them as needed.

## Fish Design

The [Fish design goals](https://fishshell.com/docs/current/design.html) are inspiring read.

- Law of Orthogonality. Don't implement multiple ways to do the same thing.
- Law of Responsiveness. Be responsive to the user at all times.
- Configurability is the Root of All Evil.  Don't add unnecessary configuration.
- Law of User Focus.  Work backwards from the user.
- Law of Discoverability.  Make features be self explanatory.

## Variables

To access a variable use `$`, e.g. `$PATH`, `$status`, etc..

To generate a sub-expression use brackets `(...)`, e.g. `(which fish)`, `(ls -1)`

The only data types in Fish are strings and lists of strings. Lists are generated from strings separated by whitespace.

Double quoted strings `"..."` interpret `$` variables.  Single quoted strings `'...'` don't.

## Commands & Variables

Everything in `fish` is a command!  You can separate commands on a single line with semi-colon `;`.

Explore the following critical commands:

- [`set`](https://fishshell.com/docs/current/cmds/set.html)
- [`fish_add_path`](https://fishshell.com/docs/current/cmds/fish_add_path.html)
- [`test`](https://fishshell.com/docs/current/cmds/test.html)
- [`not`](https://fishshell.com/docs/current/cmds/not.html)
- [`if`](https://fishshell.com/docs/current/cmds/if.html)
- [`function`](https://fishshell.com/docs/current/cmds/function.html)
- [`alias`](https://fishshell.com/docs/current/cmds/alias.html) Just a wrapper for `function`!

> In the `if` command, a zero exit code is interpreted as `true` and non-zero is `false` but there is no `boolean` type in Fish!

Less common, but you will sometimes want:

- [`string`](https://fishshell.com/docs/current/cmds/string.html)
- [`for ... in ...`](https://fishshell.com/docs/current/cmds/for.html)
- [`count`](https://fishshell.com/docs/current/cmds/count.html)
- [`fish_config`](https://fishshell.com/docs/current/cmds/fish_config.html)

And these variables:

- [`$status`](https://fishshell.com/docs/current/language.html#the-status-variable)

## Fish vs. Zsh

Fish is simpler and does everything that Zsh does! But read this if you are interested in comparing [Fish vs. Zsh](https://www.educba.com/fish-vs-zsh/).

## Package Managers

### Oh My Fish!

There's a package manager for Fish too called [Oh-My-Fish!](https://github.com/oh-my-fish/oh-my-fish) if you really love shell customizations.

### Fisher

Another package manager is [Fisher](https://github.com/jorgebucaran/fisher). Install with `curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher`.
