# Install a Read-Only Repository Mirror Using Git Server on Ubuntu 16.04

Neither GitHub or BitBucket have a feature that allows you to share read-only access to a private repository to an unlimited number of users.  You can easily do it from your own server.

These instructions show you how to install a Git server in such a way that you can serve multiple repositories, with each repository having different users that can access it.

First, install git, nginx & fcgiwrap:

```
sudo apt-get install -y git nginx fcgiwrap
```

Create a directory for your users repositories:

```
cd ~
mkdir -p git/<user>
```

Clone the remote repo under this users directory as a _mirror_ repository:

```
cd ~/git/<user>
git clone --mirror git@github.com/<user>/<repo>.git
cd <repo>.git
git remote set-url --push origin no_push
```

Because the `nginx` will access the mirrored repository with the `www-data` user, nobody will be able to push to this repository.  But the error message given will be rather unfriendly.  To make the repository read-only in a friendly way, add a file `~/git/<user>/<repo>.git/hooks/pre-receive` containing:

```
#!/bin/bash
echo "=================================================="
echo "This repository is read-only. Please contact"
echo "support@<your-domain> for more information."
echo "=================================================="
exit 1
```

Now, to update the mirror in future simply do:

```
git remote update
```

This will fetch new changes from the remote.

Now, create a basic auth password file:

```
cd ~/git/<user>
htpasswd -cb .htpasswd <user> <password>
```

Make sure your password is at least 16 characters long.

Create an `<your-domain>.conf` file for nginx containing:

```
server {
  listen 80;

  return 301 https://$host$request_uri;
}

server {
  listen 443 ssl;
  server_name <your-domain>;

  ssl_certificate /etc/nginx/ssl/<your-domain>_chained.crt;
  ssl_certificate_key /etc/nginx/ssl/<your-domain>.key;
  ssl_session_cache shared:SSL:1m;
  ssl_session_timeout 5m;
  ssl_ciphers HIGH:!aNULL:!MD5;
  ssl_prefer_server_ciphers on;

  location ~ /<user>(/.*) {
    root /home/ubuntu/git/<user>/;

    auth_basic "<User> Repositories";
    auth_basic_user_file /home/ubuntu/git/<user>/.htpasswd;

    # Set chunks to unlimited, as the body's can be huge
    client_max_body_size 0;

    fastcgi_param SCRIPT_FILENAME /usr/lib/git-core/git-http-backend;
    include fastcgi_params;
    fastcgi_param GIT_HTTP_EXPORT_ALL "";
    fastcgi_param GIT_PROJECT_ROOT /home/ubuntu/git/<user>;
    fastcgi_param PATH_INFO $1;

    # Forward REMOTE_USER as we want to know when we are authenticated
    fastcgi_param REMOTE_USER $remote_user;
    fastcgi_pass unix:/var/run/fcgiwrap.socket;
  }
}
```

Then `systemctl restart nginx` and test by trying to clone the repo:

```
git clone https://<user>:<password>@<your-domain>/<user>/<repo>.git
```

There is a StackOverflow answer on this [here](https://stackoverflow.com/a/36362218/576235).

