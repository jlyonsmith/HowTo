# Install Git

## Default Git Config

Use `git config --edit --global` and set:

```ini
[user]
name = John Lyon-Smith
email = <email-here>

[core]
editor = /usr/local/bin/code -w
autocrlf = false
excludesfile = /Users/jolyonsm/.gitignore_global

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
prq = pull-request
brw = browse
reb = rebase
rst = reset
upr = !git fetch upstream && git rebase upstream/master
upm = !git fetch upstream && git merge upstream/master
brw = !git-extra browse
prq = !git-extra pull-request
qst = !git-extra quick-start
dag = log --graph --format='format:%C(yellow)%h%C(reset) %C(blue)%an <%ae>%C(reset) %C(magenta)%cr%C(reset)%C(auto)%d%C(reset)%n%s' --date-order

[pull]
rebase = false

[init]
defaultBranch = main

[diff]
tool = araxis

[merge]
tool = araxis

[commit]
template = /Users/jolyonsm/.stCommitMsg
```
