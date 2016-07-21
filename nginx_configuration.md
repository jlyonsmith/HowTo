Here are some common `nginx` configurations.  Place them in the `conf.d` directory under `/usr/local/etc/nginx` or `/etc/nginx`.

#### Configure Reverse Proxy

Use the following as a base for setting up reverse proxying:

	server {
	  listen 80;
	  server_name api.tsonspec.org;
	  location /v1/ {
	    valid_referers tsonspec.org;
	
	    if ($invalid_referer) {
	      return 403;
	    }
	
	    proxy_pass http://127.0.0.1:1340/;
	    proxy_buffering off;
	    proxy_redirect off;
	    proxy_set_header X-Forwarded-Host $host;
	    proxy_set_header X-Forwarded-Server $host;
	    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
	  }
	}

This sets up a proxy for `http://api.tsonspec.org/v1/` to redirect to a service running on `http://localhost:1340/` and only allows access from the domain `tsonspec.org`.

#### Configure SSL/HTTPS Site

Create a `/etc/nginx/ssl` directory.  Copy the `mydomain_com_chained.crt` and `api_mydomain_com.key` files into it.

Use the following file to configure the HTTPS site in `/etc/nginx/conf.d`:

```
server {
  listen 443 ssl;
  server_name api.xyz.com;
  ssl_certificate /etc/nginx/ssl/api_xyz_com_chained.crt;
  ssl_certificate_key /etc/nginx/ssl/api_xyz_com.key;

  ssl_session_cache shared:SSL:1m;
  ssl_session_timeout 5m;

  ssl_ciphers HIGH:!aNULL:!MD5;
  ssl_prefer_server_ciphers on;

  location /v1/ {
    proxy_pass http://localhost:1337/;
    proxy_buffering off;
    proxy_redirect off;
    proxy_set_header X-Forwarded-Host $host;
    proxy_set_header X-Forwarded-Server $host;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
  }
}
```

#### Configure AngularJS App

A web server for serving AngularJS with # rewriting.

```
server {
  server_name admin.xyz.com;
  location / {
    # allow 207.118.87.34;
    # deny all;
    root /home/ubuntu/Admin;
    index index.html;

    # Redirect any non-resource specific requests so that AngularJS can handle them
    rewrite "^(/(?!\#/)[^\.]+?(?!\..+))$" /#$1 redirect;
  }
}
```

#### Configure Server Side App

Assuming a web server running on `localhost:2012`.

```
server {
  server_name whoami.xyz.com;

  location / {
    proxy_pass http://localhost:2012/;
    proxy_buffering off;
    proxy_redirect off;
    proxy_set_header X-Forwarded-Host $host;
    proxy_set_header X-Forwarded-Server $host;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
  }
}
```
