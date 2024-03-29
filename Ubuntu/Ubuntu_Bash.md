# Settings for Ubuntu Bash Shell

## Clean Up Message-of-the-Day

```bash
sudo -s
cd /etc/update-motd.d
rm 10-help-text 50-motd-news 80-esm 80-livepatch 95-hwe-eol 97-overlayroot
exit
```

## `.vimrc`

```vim
color desert
set shiftwidth=2 tabstop=2 expandtab
```

## Git Completion

Install [Git completion scripts](https://github.com/git/git/tree/master/contrib/completion) to `/usr/local/etc/bash_completion.d/`.

```bash
sudo -s
cd /usr/local/etc
mkdir bash_completion.d
cd bash_completion.d
wget https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash
wget https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh
exit
```

## `.bash_profile`

For a dev machine:

```bash
# The interactive shell start-up file
# You can safely echo stuff to the terminal in here

[[ -r ~/.bashrc ]] && source ~/.bashrc

title $(hostname)
```

## `.bashrc`

Here are my recommended settings for `~/.bashrc`:

```bash
# The individual non-interactive shell startup file
# DO NOT print anything in this script or you will break the SCP protocol

GIT_COMPLETION_SCRIPT=/usr/local/etc/bash_completion.d/git-completion.bash
GIT_PROMPT_SCRIPT=/usr/local/etc/bash_completion.d/git-prompt.sh

[[ -r "$GIT_COMPLETION_SCRIPT" ]] && source $GIT_COMPLETION_SCRIPT

PROMPT_1="[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]"
PROMPT_2="]\n\$"

if [[ -f "$GIT_PROMPT_SCRIPT" ]]; then
  source $GIT_PROMPT_SCRIPT

  GIT_PS1_SHOWDIRTYSTATE=1
  GIT_PS1_SHOWUNTRACKEDFILES=1
  GIT_PS1_SHOWUPSTREAM=1
  GIT_PS1_SHOWCOLORHINTS=1

  export PS1=''
  export PROMPT_COMMAND="__git_ps1 \"${PROMPT_1}\" \"${PROMPT_2}\""
else
  export PS1="${PROMPT_1}${PROMPT_2}"
fi

unset GIT_PROMPT_SCRIPT
unset GIT_COMPLETION_SCRIPT
unset PROMPT_1
unset PROMPT_2

export EDITOR='vim'
export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced

# History
export HISTCONTROL=ignoredups:erasedups

# Function for setting terminal titles
function title {
  printf "\x1b]0;%s\x7" "$1"
}

# Function for setting iTerm2 tab colors
function tab-color {
  printf "\x1b]6;1;bg;red;brightness;%s\x7" "$1"
  printf "\x1b]6;1;bg;green;brightness;%s\x7" "$2"
  printf "\x1b]6;1;bg;blue;brightness;%s\x7" "$3"
}

#Aliases
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias grep='grep --color=auto'
alias ll='ls -al'
alias ls='ls --color=auto'
alias edit="vi"
alias bn="babel-node"
alias node=alias node="NODE_NO_READLINE=1 rlwrap -pcyan node"
alias ipts="iptables-save"
alias iptr="iptables-restore"
```

For a bastion or other machine a simpler script will suffice:

```bash
# The individual non-interactive shell startup file
# DO NOT print anything in this script or you will break the SCP protocol

PROMPT_1="[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]"
PROMPT_2="]\n\$"

export PS1="${PROMPT_1}${PROMPT_2}"

unset PROMPT_1
unset PROMPT_2

export EDITOR='vi'
export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced

# History
export HISTCONTROL=ignoredups:erasedups

# Function for setting terminal titles
function title {
  printf "\x1b]0;%s\x7" "$1"
}

#Aliases
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
alias grep='grep --color=auto'
alias ll='ls -al'
alias ls='ls --color=auto'
alias ipts="iptables-save"
alias iptr="iptables-restore"
```