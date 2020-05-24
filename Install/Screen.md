# Screen

Installs over `ssh` can be a pain if you get disconnected from the network during the installation. For long running operations where you might lose `ssh` connectivity (or you just want to disconnect instead of waiting) you can use `screen` before a long running operation:

    apt-get install screen
    screen

Then, if you get kicked off, just run:

    screen -r

to reconnect and get back to work.
