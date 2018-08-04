# Change Ubuntu User Name

Don't change your logged in user. Log in as a different user and then:

1.  `sudo -s`.
1.  `usermod -l newUsername oldUsername`.
1.  `usermod -d /home/newHomeDir -m newUsername` to change the home folder.

If you only have a single user (often the case) you have to create a temporary user with sudo privs.:

1.  Login with your credentials.
1.  `sudo -s`
1.  Add a new user, `adduser temporary`, then `passwd temporary`.
1.  Add the user the `wheel` group, `usermod -aG wheel temporary`
1.  `exit` the shell
1.  `ssh temporary@a.b.c.d`, with `temporary` password.
1.  Now apply the changes above.
1.  `exit` the shell
1.  `ssh newUsername@a.b.c.d`
1.  Clean-up with `userdel -r temporary`
