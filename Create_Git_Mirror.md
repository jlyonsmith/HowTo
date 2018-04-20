# Create a Git Mirror

```
git clone --mirror git@github.com/user/repo.git
cd repo.git
git remote set-url --push origin no_push
```

To update the mirror in future:

```
git remote update
```
