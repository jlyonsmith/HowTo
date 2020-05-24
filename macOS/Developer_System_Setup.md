# macOS Developer System Setup

These instructions assume a clean installation of macOS (at least High Sierra or above) and that you are logged on as an administrator user, i.e. you can run `sudo`.

## Install iTerm2

Download and install [iTerm2](https://www.iterm2.com/). Open _Preferences_ and duplicate the default profile:

![iterm2](images/iterm2-prefs-1.png)

Set the _Working Directory_ to _Reuse previous session directory_.

Go to the _Keys_ tab. Delete all key shortcuts, and add two for **&#8997; &#8592;** and **&#8997; &#8594;** as shown.

![iterm2](images/iterm2-prefs-2.png)

Select _Send Escape Sequence_ from the really long drop-down menu, and the type `b` or `f`.

## SSH

You need a 4096 bit RSA key with a passphrase.

```sh
ssh-keygen -t rsa -b 4096 -C "your_email@example.com" -f <your-alias>
```

Note, you are **not** overwriting your current default `id_rsa`/`id_rsa.pub` key pair.

Upload

Then add the private key to your local `ssh-agent` with:

```sh
ssh-add ~/.ssh/<your-alias>
```

Now, ensure you can reach BitBucket with:

```sh
ssh -T git@bitbucket.org
logged in as <user_name>
```

And GitHub:

```sh
ssh -T git@github.com
Hi <user-name>! You've successfully authenticated, but GitHub does not provide shell access.
```

On Ubuntu, a simple way to run the `ssh-agent` is to do:

```sh
eval $(ssh-agent -s)
ssh-add ~/.ssh/id_rsa
```

## Install Homebrew

_NOTE: Be careful!!! There is a Trojan Horse site parked at `http://homebrew.sh` that looks like the Homebrew site but which actually attempts to install malware._

Go to [Homebrew](https://brew.sh), copy the line and run it:

![homebrew](images/homebrew.png)

Run `brew doctor` and _fix all the problems that it tells you about_. One of the issues will probably be installation of Xcode (see below)

NOTE: You do not need or want to be `sudo` when you install Homebrew. If you have installed Homebrew with `sudo`, uninstall it and re-install as yourself.

## Install Visual Studio code

Download [Visual Studio Code](https://code.visualstudio.com/download) and install to _Applications_.

Run it, type **&#8984; Shift P** then search for and run "Shell command: Install 'code' command in PATH".

Install the packages:

- [Prettier](https://marketplace.visualstudio.com/items?itemName=esbenp.prettier-vscode)
- [Toggle Quotes](https://marketplace.visualstudio.com/items?itemName=BriteSnow.vscode-toggle-quotes)
- [JSON5 Syntaxt](https://marketplace.visualstudio.com/items?itemName=mrmlnc.vscode-json5)
- [Property List](https://marketplace.visualstudio.com/items?itemName=zhouronghui.propertylist)

Override the default `keybindings.json` file with:

```json
[
  {
    "key": "shift+alt+cmd+f",
    "command": "workbench.action.replaceInFiles"
  },
  {
    "key": "shift+cmd+h",
    "command": "-workbench.action.replaceInFiles"
  }
]
```

Add the following settings:

```json
{
  "window.zoomLevel": 0,
  "javascript.implicitProjectConfig.experimentalDecorators": true,
  "editor.minimap.enabled": false,
  "explorer.confirmDragAndDrop": false,
  "files.trimTrailingWhitespace": true,
  "editor.tabSize": 2,
  "workbench.startupEditor": "newUntitledFile",
  "extensions.ignoreRecommendations": true,
  "explorer.confirmDelete": false,
  "editor.formatOnSave": false,
  "[javascript]": {
    "editor.formatOnSave": true
  },
  "[json]": {
    "editor.autoIndent": false
  },
  "javascript.updateImportsOnFileMove.enabled": "never",
  "breadcrumbs.enabled": true
}
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

## Git Prompt

To install a Git prompt, do the following:

```zsh
mkdir ~/.zsh
cd ~/.zsh
git clone git@github.com:jlyonsmith/zsh-git-prompt.git
```

## Install Java

Install [Java](http://www.oracle.com/technetwork/java/javase/downloads/index.html) by downloading the appropriate installer:

![java](images/java-se-install.png)

## Zsh Setup

Setup your `zsh` environment now. First do `cd ~; mkdir bin`.

Create a `~/.zprofile` file that contains just this:

```zsh
# The personal initialization file, executed for login shells
[[ -r ~/.zshrc ]] && source ~/.zshrc
```

Then create a `~/.zshrc` file that contains:

```zsh
# The individual per-interactive-shell startup file

autoload zmv

# Set default editor
export EDITOR='code -w'

# History
export HISTCONTROL=ignoredups:erasedups

# cd shortcuts
export CDPATH=.:~/Projects

# Function for setting terminal titles in OSX
function title {
  printf "\x1b]0;%s\x7" "$1"
}

# Function for setting iTerm2 tab colors
function tab-color {
  printf "\x1b]6;1;bg;red;brightness;%s\x7" "$1"
  printf "\x1b]6;1;bg;green;brightness;%s\x7" "$2"
  printf "\x1b]6;1;bg;blue;brightness;%s\x7" "$3"
}

# Prompt
source ~/.zsh/zsh-git-prompt/zshrc.sh

export PROMPT='[%F{#99E343}%n@%m%f:%F{#83B0D8}%~%f$(git_super_status)]'$'\n''$'
export RPROMPT=''

# Android SDK
export ANDROID_HOME="$HOME/Library/Android/sdk"
export PATH="$PATH:$ANDROID_HOME/emulator"
export PATH="$PATH:$ANDROID_HOME/tools"
export PATH="$PATH:$ANDROID_HOME/platform-tools"

# GoLang
export PATH="$PATH:$HOME/go/bin"

# Get IP address
export LOCAL_IP_ADDR=$(ipconfig getifaddr en0)

alias edit="code"
alias bn="babel-node"
alias mq=rabbitmqctl
alias an=ansible
alias ap=ansible-playbook
alias ag=ansible-galaxy
alias ll="ls -al"
alias pg=password-generator

# Ruby version manager
if which rbenv > /dev/null; then
    eval "$(rbenv init -)"
fi

# Node version manager
if which nodenv > /dev/null; then
    eval "$(nodenv init -)"
fi

# Java
export JAVA_HOME=$(/usr/libexec/java_home)

# Brew
export PATH="$HOME/bin:$PATH:/usr/local/share/npm/bin:/usr/local/sbin"

# Tcl/Tk
export PATH="/usr/local/opt/tcl-tk/bin:$PATH"

# Araxis Merge
export PATH="$PATH:/Applications/Araxis\ Merge.app/Contents/Utilities"

# Disable insecure completion directory warning
ZSH_DISABLE_COMPFIX=true
```

## Install SuperDuper!

Install the [SuperDuper!](https://www.shirt-pocket.com/SuperDuper/SuperDuperDescription.html) software. This is the software we use for back-ups.

## Install ClamXAV

Install [ClamXAV](https://www.clamxav.com/) virus checker. This is required for PCI compliance.

## Install Xcode

Install [Xcode](https://itunes.apple.com/us/app/xcode/id497799835?mt=12) from the App Store.

Run Xcode after it downloads, and wait for it to initialize. Then run the following on the command line:

```zsh
xcode-select --install
```

to install the command line tools. You can also run `brew doctor` which will tell you how to do this also.

## Install Image Libraries

`brew install pkg-config cairo libpng jpeg giflib` to support using the [canvas](https://www.npmjs.com/package/canvas) library.

## Install Ansible

`brew install ansible`

## Install RabbitMQ

`brew install rabbitmq` then `brew services start rabbitmq`

## Install Redis

`brew install redis` then `brew services start redis`

## Install MongoDB

- `brew tap mongodb/brew`
- `brew install mongodb-community`
- `brew services start mongodb-community`

## Install nginx

`brew install nginx` then `brew services start nginx`

## Install PostgreSQL

`brew install postgresql` then `brew services start postgresql`

## Install Consul

We use consul in production for dynamic configuration of the backend cluster.

First, install `consul`:

```zsh
brew install consul
```

Then, edit the `.plist` file that is installed, `edit /usr/local/Cellar/consul/1.2.3/homebrew.mxcl.consul.plist` to contain:

```plist
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <dict>
    <key>KeepAlive</key>
    <dict>
      <key>SuccessfulExit</key>
      <false/>
    </dict>
    <key>Label</key>
    <string>homebrew.mxcl.consul</string>
    <key>ProgramArguments</key>
    <array>
      <string>/usr/local/opt/consul/bin/consul</string>
      <string>agent</string>
      <string>-server</string>
      <string>-bind</string>
      <string>127.0.0.1</string>
      <string>-bootstrap</string>
      <string>-data-dir</string>
      <string>/usr/local/var/consul</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>WorkingDirectory</key>
    <string>/usr/local/var</string>
    <key>StandardErrorPath</key>
    <string>/usr/local/var/log/consul.log</string>
    <key>StandardOutPath</key>
    <string>/usr/local/var/log/consul.log</string>
  </dict>
</plist>
```

This will configure `consul` to persist key/value pairs locally, otherwise they will be lost on each system restart. Then `brew services start consul`.

## React Native

For React Native development:

```zsh
npm react-native-cli watchman
```

## Install SourceTree

Go to [SourceTree](https://www.sourcetreeapp.com/) and download the installer. Copy to _Applications_.

To install the command line tools, don't use the link in the app, because it assumes that the `sudo` user owns the `/usr/local/bin` directory. Instead run:

```zsh
ln -s /Applications/SourceTree.app/Contents/Resources/stree /usr/local/bin/
```
