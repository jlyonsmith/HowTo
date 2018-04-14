# Install Git Server on Ubuntu

These instructions show you how to install a Git server in such a way that you can serve multiple repositories for different users and keep each users repositories isolated.

First, install git, nginx & fcgiwrap:

```
sudo apt-get install -y git nginx fcgiwrap
```

Create a directory for your users repositories:

```
cd ~
mkdir -p git/<user>
```

Clone the remote repo under this users directory:

```
cd ~/git/<user>
git clone --bare <remote-repo>
```

Create a basic auth password file:

```
cd ~/git/<user>
htpasswd -cb .htpasswd <user> <password>
```

Make sure your password is at least 16 characters long.

Change permissions for all the files so that you can push to the repo:

```
cd ~/git/<user>
sudo chown -R www-data:www-data .htpasswd *.git
```

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