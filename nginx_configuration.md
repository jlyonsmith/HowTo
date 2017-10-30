Here are some common `nginx` configurations.  Place them in the `conf.d` directory under `/usr/local/etc/nginx` or `/etc/nginx`.

#### React App with API

```
server {
  listen 443 ssl;
  server_name xyz.com;
  ssl_certificate /etc/nginx/ssl/xyz_com_chained.crt;
  ssl_certificate_key /etc/nginx/ssl/xyz_com.key;
  ssl_session_cache shared:SSL:1m;
  ssl_session_timeout 5m;
  ssl_ciphers HIGH:!aNULL:!MD5;
  ssl_prefer_server_ciphers on;

  #allow 67.183.189.74; # user1
  #allow 24.18.144.122; # user2
  #allow 24.16.120.178; # user3
  #allow 273.63.121.153; # user4
  #deny all;

  root /home/ubuntu/xyz/website/build;

  # Any route that starts with /api/ is for the backend
  location /api/ {
    proxy_pass http://127.0.0.1:3001/;
    proxy_buffering off;
    proxy_redirect off; # API's shouldn't redirect
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection "upgrade"; # Support WebSocket upgrading
    proxy_http_version 1.1;
    proxy_set_header X-Forwarded-Host $host;
    proxy_set_header X-Forwarded-Server $host;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
  }

  # Any route containing a file extension just return or fail
  location ~ ^.+\..+$ {
      try_files $uri =404;
  }

  # Any route that doesn't have a file extension is an app route
  location / {
    try_files $uri $uri/ /index.html;
  }
}
```

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
