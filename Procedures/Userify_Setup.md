# SSH Key Setup

## Signing Up for Userify

![Userify](images/userify-main.png)

Get an invitation to [Userify](https://userify.com). Click on the link email, set your password. Fill in your desired Linux user name. Also, as a policy we want you to set up [two-factor authentication for logging in to Userify](https://userify.com/docs/multifactor-authentication/).

You can use the [Google Authenticator iOS App](https://itunes.apple.com/us/app/google-authenticator/id388497605) or [Google Authenticator Android App](https://play.google.com/store/apps/details?id=com.google.android.apps.authenticator2&hl=en_us).

Another good option for a MFA store is [Authy](https://authy.com/).

## Creating Your SSH Key & Environment

First, you need to create the `~/.ssh` directory:

```
mkdir ~/.ssh
chmod u=rwx,go=x ~/.ssh
```

This directory is where all `ssh` keys and configuration live. You want to limit access to the files in this directory, so you only give others execute permission (which means they can do an `ls` but they can access files if you give them permission.)

Now, you need to generate an **RSA** key with **4096 bits** of entropy. It must have the same email as you use in _Userify_.

```
cd ~/.ssh
ssh-keygen -b 4096 -t rsa -C "$YOUR_EMAIL_NAME@yourdomain.com" -f $YOUR_LINUX_USERNAME
```

Now protect your private key:

```
chmod u=r,go= ~/.ssh/$YOUR_LINUX_USERNAME
```

Copy your public key to the clipboard:

```
pbcopy < ~/.ssh/config
```

Now go to Userify and paste the public key into your profile:

![Userify Public Key](images/userify-public-key.png)

## Adding Your SSH key to the Keychain

Run:

```
ssh-add -K ~/.ssh/
```

Enter the key password. The key will be stored in your macOS SSH_Key_Setup/ and you should no longer have to enter the password when you use this new SSH key.

## SSH Configuration File

Create configuration file. Run `edit ~/.ssh/config`. The add an entry for each system you want to connect to:

```
Host <jump-box>
  HostName $SOME_HOST
  ProxyJump $BASTION
  User $YOUR_LINUX_USERNAME
  IdentityFile ~/.ssh/$YOUR_LINUX_USERNAME
```
