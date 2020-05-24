# Git

## Git aware prompt and auto-complete

Copy [git-aware.sh and git-completion.sh](https://github.com/git/git/tree/master/contrib/completion) scripts from the Git repo on GitHub.

## Basics

Add tracked as well as untracked to the index:

```sh
git add -A .
```

Checkout a specific version:

```sh
git checkout <tagName>
git checkout <branchName>
```

Show status:

```sh
git status
```

Commit the index:

```sh
git commit
```

Commit index with message:

```sh
git commit - m "<message>"
```

Re-commit last change:

```sh
git commit —-amend
```

Stop tracking a folder or file

```sh
git rm -r --cached <path>
```

## Configuration

Show local & global configuration:

```sh
git config -l
```

Edit global configuration:

```sh
git config --edit --global
```

## Large File Removal

Get rough size of repo:

```sh
git count-objects -vH
```

Find largest objects in the repo:

```sh
git rev-list --objects --all \
| git cat-file --batch-check='%(objecttype) %(objectname) %(objectsize) %(rest)' \
| sed -n 's/^blob //p' \
| sort --numeric-sort --key=2
```

Mark the files you don't want for removal:

```sh
git filter-branch -f --index-filter "git rm -rf --cached --ignore-unmatch FILE_OR_FOLDER" -- --all
```

Then, to actually redact entries from a repo and re-write Git history use:

```sh
rm -rf .git/refs/original/
git reflog expire --expire=now --all
git gc --prune=now
git gc --aggressive --prune=now
git push --all --force
```

## Advanced

Refresh `.gitignore`:

```sh
git rm -r --cached .
git add .
```

## Merging

Merge another branch to this one:

```sh
git merge <branch>
```

Abort a merge:

```sh
git merge —-abort
```

Merge taking all changes from the source branch:

```sh
git merge -X theirs <branch>
```

Cherry pick a change, unstage it, select which bits to apply, commit it:

```sh
git cherry-pick -n <commit>
git reset
git add -p
git commit
```

## Branches

Create a new local branch:

```sh
git checkout -b <name>
```

Checkout and track an existing remote branch that you have just pulled:

```sh
git checkout -t <remote>/<branch>
```

Change remote tracking branch for a local branch:

```sh
git branch -u <remote>/<branch> <branch>
```

Create and track a new remote branch from a local branch:

```sh
git push -u <remote> <branch>
```

Show all local and remote branches (may need to refresh; see below):

```sh
git branch # local
git branch -r # remote
git branch -a  # all
```

Show local and remote tracking branches:

```sh
git branch -vv
```

Refresh remote branch information:

```sh
git remote prune origin
```

Rename current local branch:

```sh
git branch -m <name>
```

Delete a local branch:

```sh
git branch -D <name>
```

Delete a remote branch:

```sh
git push --delete <remote> <branchName>
```

Show branches which have been merged into this branch:

```sh
git branch --merged
```

## Remotes

Show all remote repositories:

```sh
git remote -v
```

## Tags

Create a tag:

```sh
git tag -am “<message>” tag
```

Delete a tag locally:

```sh
git tag -d <tagname>
```

Delete a tag remotely:

```sh
git push  --delete <remote> tags/<tagname>
```

Push local tags remotely:

```sh
git push --tags
```

## Patches

To make a patch file from unstaged changes:

```sh
git diff > <patch-file>.patch
```

From staged changes:

```sh
git diff --cached > <patch-file>.patch
```

To apply the patches in another repository:

```sh
git apply <patch-file>.patch
```

To create a set of numbered patches from a certain commit onward:

```sh
git format-patch -o <output-dir> <commit>
```

To apply multiple patches in numbered patch files:

```sh
git am <patch-dir>/*.patch
```

## Stashes

Pop/apply stash without merging:

```sh
git checkout stash -- .
```

## Submodules

Remove a sub-module:

```sh
git submodule deinit <submodule>
git rm <submodule>
```
