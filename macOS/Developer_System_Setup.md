# macOS Developer System Setup

These instructions assume a clean installation of macOS Big Sur or Monterey and that you are logged on as an administrator user, i.e. you can run `sudo`.

## Security

Add an additional fingerprint in **System Preferences -> TouchID**

Enable watch unlock in **System Preferences -> Security & Privacy** if you have a watch!

## Dock

Turn on "Automatically hide and show the Dock" in **System Preferences -> Dock & Menu Bar**

## Install Homebrew

_NOTE: Be careful!!! There is a Trojan Horse site parked at `http://homebrew.sh` that looks like the Homebrew site but which actually attempts to install malware._

Go to [Homebrew](https://brew.sh), copy the line and run it:

![homebrew](images/homebrew.png)

Add `brew` to the path with `export PATH=$PATH:/opt/homebrew/bin`. Run `brew doctor` and _fix all the problems that it tells you about_.

> You *do not need to or want* to be `sudo` when you install Homebrew. If you have installed Homebrew with `sudo`, uninstall it and re-install as yourself.

## SSH

Copy your SSH key from your previous machine backup or  generate a new one with a passphrase:

```sh
ssh-keygen -t ed25519 -C "your_email@example.com"
```
```

Then add the private key to your local `ssh-agent` with:

```sh
ssh-add ~/.ssh/<your-alias>
```

## Install Fonts

Install:

- [Hack Nerd Font](https://www.nerdfonts.com/font-downloads)
- [Myriad Pro](https://fontsgeek.com/myriad-pro-font) for presentations

## Install VSCode

Install [VSCode](https://code.visualstudio.com/).  Do **⌘ Shift  P** and run "Install code to PATH".

## Install Browsers

- [Chrome](https://www.google.com/chrome/)
- [Firefox](https://www.mozilla.org/en-US/firefox/new/)
- [Edge](https://www.microsoft.com/en-us/edge)

## Install iTerm2

Download and install [iTerm2](https://www.iterm2.com/). Go to

## Install Visual Studio code

Download [Visual Studio Code](https://code.visualstudio.com/download) and install to _Applications_.

Run it, type **&#8984; Shift P** then search for and run "Shell command: Install 'code' command in PATH".  Also run "Settings Sync: Turn On" and use GitHub to synchronize settings.

## Install Rust

Install [rustup](https://rustup.rs/).

## Configure Zsh

Copy `~/.zshrc` from another machine.

## Install Starship

`brew install starship`.

Use this config in `starship config`:

```toml
# Don't print a new line at the start of the prompt
add_newline = false

[aws]
disabled = true

[directory]
truncate_to_repo = false
truncation_length = 8
truncation_symbol = ".../"
```

## Install Node.js

Upgrade default [Node.js](https://nodejs.org/en/).

```sh
brew install node nodenv
```

## Install Ruby

Install [rbenv](https://github.com/rbenv/rbenv) with `brew install rbenv`.

Install a specific version of Ruby, say `rbenv install 2.3.7` then switch the system version over to it, `rbenv global 2.3.7`.

## Install Node.js

`brew install node`. Ensure that `npm` is up-to-date with `npm i -g npm`.

Do `npm install -g snap-tool stampver monzilla bitbucket-tool consul-tool`

To support Node.js development.

## Install nodenv

`brew install nodenv`. This is used to regress Node.js versions as needed.

## Install git

Do `brew install git`.

Edit the global config with `git config --edit --global` (which will open the file in `vi`). Go to a point in the file, type `i` to insert then paste:

```ini
[user]
  name = Your Name
  email = you@your-company.com

[core]
  editor = /usr/local/bin/code -w
  autocrlf = false
  excludesfile = /Users/you/.gitignore_global

[alias]
  ada = add -A :/
  st = status -sb
  sta = status -sb
  com = commit
  bra = branch
  chk = checkout
  dto = difftool
  mto = mergetool
  mrg = merge
  log = log -p
  sub = submodule
  fch = fetch -v
  rem = remote
  psh = push
  pll = pull
  ash = stash
  cfg = config
  chp = cherry-pick
  lst = ls-tree -r --name-only
  reb = rebase
  rst = reset
  upr = !git fetch upstream && git rebase upstream/master
  upm = !git fetch upstream && git merge upstream/master
  brw = !git-extra browse
  prq = !git-extra pull-request
```

Install [`@johnls/git-extra`](https://www.npmjs.com/package/@johnls/git-extra) with `npm install -g @johnls/git-extra`

## Install Java

Install [Java](http://www.oracle.com/technetwork/java/javase/downloads/index.html) by downloading the appropriate installer:

![java](images/java-se-install.png)

## Install SuperDuper!

Install the [SuperDuper!](https://www.shirt-pocket.com/SuperDuper/SuperDuperDescription.html) software. This is the software we use for back-ups.

## Install Xcode

Install [Xcode](https://itunes.apple.com/us/app/xcode/id497799835?mt=12) from the App Store.

Run Xcode after it downloads, and wait for it to initialize. Then run the following on the command line:

```zsh
xcode-select --install
```

to install the command line tools. You can also run `brew doctor` which will tell you how to do this also.

## Install Android Studio

Download and install [Android Studio](https://developer.android.com/studio).

## Install Flutter

Clone the repo [`flutter`](https://github.com/flutter/flutter) repo.  Run `bin/flutter`.

## Install Zoom

Go to [Zoom](https://zoom.us/) and host a meeting to download the app.

## Install SourceTree

Go to [SourceTree](https://www.sourcetreeapp.com/) and download the installer. Copy to _Applications_.

To install the command line tools, don't use the link in the app, because it assumes that the `sudo` user owns the `/usr/local/bin` directory. Instead run:

```zsh
ln -s /Applications/SourceTree.app/Contents/Resources/stree /usr/local/bin/
```

## BitBucket

Ensure you can reach BitBucket with:

```sh
ssh -T git@bitbucket.org
logged in as <user_name>
```

## GitHub

Ensure you can reach GitHub:

```sh
ssh -T git@github.com
```

You'll get the message: `Hi <user-name>! You've successfully authenticated, but GitHub does not provide shell access.`