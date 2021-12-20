# Running `ssh-agent` on Ubuntu

On Ubuntu you have to run the `ssh-agent` manually with:

```sh
eval $(ssh-agent -s)
ssh-add ~/.ssh/id_rsa
```
