# Change Ubuntu User Name

If you only have a single user (often the case) then:

1. Login with your credentials and add a new user, `sudo adduser temporary` and set the password.
2. Allow the temporary user to run sudo by adding the user to sudo group, `sudo adduser temporary sudo`
3. `exit` the shell
4. `ssh temporary@a.b.c.d`, with `temporary` password.
5. Change user name with `sudo usermod -l newUsername oldUsername`
6. Change user home folder with `sudo usermod -d /home/newHomeDir -m newUsername`
7. `exit` the shell
8. `ssh newUsername@a.b.c.d`
9. Clean-up with `sudo deluser temporary; sudo rm -r /home/temporary`

If not, you can use steps 5 & 6 only.
