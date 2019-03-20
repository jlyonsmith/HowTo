# Git

## Git aware prompt and auto-complete

Copy [git-aware.sh and git-completion.sh](https://github.com/git/git/tree/master/contrib/completion) scripts from the Git repo on GitHub.

## Basics

Add tracked as well as untracked to the index: 

    git add -A .

Checkout a specific version:

    git checkout <tagName>
    git checkout <branchName>

Show status:

    git status

Commit the index:

    git commit

Commit index with message:

    git commit - m "<message>"

Re-commit last change:

    git commit —-amend

Stop tracking a folder or file

    git rm -r --cached <path>

## Configuration

Show local & global configuration:

    git config -l

Edit global configuration:

    git config --edit --global
    
## Maintenance    

Get rough size of repo:

    git count-objects -vH
    
Find largest objects in the repo:

```
git rev-list --objects --all \
| git cat-file --batch-check='%(objecttype) %(objectname) %(objectsize) %(rest)' \
| sed -n 's/^blob //p' \
| sort --numeric-sort --key=2
```

To redact entries from a repo and re-write Git history use [BFG Repo Cleaner](https://rtyley.github.io/bfg-repo-cleaner/) installed with `brew install bfg`.

After running do:

    git reflog expire --expire=now --all && git gc --prune=now --aggressive
    
## Advanced

Refresh `.gitignore`:

    git rm -r --cached .
    git add .

## Merging

Merge another branch to this one:

    git merge <branch>

Abort a merge:

    git merge —-abort
    
Merge taking all changes from the source branch:

    git merge -X theirs <branch>

Cherry pick a change, unstage it, select which bits to apply, commit it:

```
git cherry-pick -n <commit>
git reset
git add -p
git commit
```

## Branches

Create a new local branch:

    git checkout -b <name>

Checkout and track an existing remote branch that you have just pulled:

    git checkout -t <remote>/<branch>

Change remote tracking branch for a local branch:

    git branch -u <remote>/<branch> <branch>

Create and track a new remote branch from a local branch:

    git push -u <remote> <branch>

Show all local and remote branches (may need to refresh; see below):

    git branch # local
    git branch -r # remote
    git branch -a  # all

Show local and remote tracking branches:

    git branch -vv

Refresh remote branch information:

    git remote prune origin

Rename current local branch:

    git branch -m <name>

Delete a local branch:

    git branch -D <name>
    
Delete a remote branch:

    git push --delete <remote> <branchName>

Show branches which have been merged into this branch:

    git branch --merged	

## Remotes 

Show all remote repositories:

	git remote -v

## Tags

Create a tag:

    git tag -am “<message>” tag
    
Delete a tag locally:

    git tag -d <tagname>

Delete a tag remotely:

    git push  --delete <remote> tags/<tagname>

Push local tags remotely:

    git push --tags

## Patches

To make a patch file from unstaged changes:

    git diff > <patch-file>.patch
    
From staged changes:

    git diff --cached > <patch-file>.patch
    
To apply the patches in another repository:

    git apply <patch-file>.patch

## Stashes

Pop/apply stash without merging:

    git checkout stash -- .

## Submodules

Remove a sub-module:

    git submodule deinit <submodule>
    git rm <submodule>
