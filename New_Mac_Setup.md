# New Mac Setup

This document gives details on setting up a new Mac.

## Chrome

Install [Chrome](https://www.google.com/chrome/browser/desktop/index.html).  After installation install [LastPass](https://lastpass.com/misc_download2.php)

## Safari

Install [LastPass](https://lastpass.com/misc_download2.php) [and Ad Block Plus](https://adblockplus.org) from the Safari extensions under the `Safari` menu.

## Hide My Ass!

Install [Hide My Ass!](https://www.hidemyass.com/en-us/index)

## Micro Torrent

Install [Micro Torrent](http://www.utorrent.com/)

## Atom

Install [Atom](http://atom.io).  Install the following packages:

- `todo`
- `

## Dropbox

Install [Dropbox](https://www.dropbox.com/install)

## Mou

Install [Mou](http://mouapp.com/).  Download, unzip, go to the `Downloads` folder and drag the file to the _Applications_ folder.

## Xcode

Install Xcode from the App Store.

## Environment Tweaks

Run:

	cd ~
	bin/edit .bashrc
	
Paste in at least the following:

	PS1="[\u@\h:\w]\n\$"
	export EDITOR='subl'
	export PATH="$HOME/bin:${PATH}"

Save and close.  Now run:

	edit .bash_profile

And paste in:

	. ~/.bashrc
	
Now you can type:

	edit xyz.txt

to edit files from the command line in _Sublime Text_.

#### Xcode

Download and install Xcode using the _App Store_.  You will need to verify your Apple ID.  This is a 2.5GB install so it will take some time!

Install an other updates at this time too.

#### Homebrew

We are using the Homebrew package manager for OSX to install command line software.  To install, open a _Terminal_ window and paste in:

	ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"
	
You will need to enter the _Administrator_ password and you may need to install the _XCode Command Line Tools_.

Ensure that you get the following:

	$brew doctor
	Your system is ready to brew.
	
You also need to fix your `PATH` so that `/usr/local/bin` appears before `/usr/bin` or Homebrew installed components will not take precidence over system ones:

	sudo edit /etc/paths
	
And make it look like:

	/usr/local/bin
	/usr/bin
	/bin
	/usr/sbin
	/sbin
	
Type in your _Administrator_ password to save it.  Restart your _Terminal_ shell.

#### Karabiner (KeyMapper)

If you use the Mac full size 101-key keyboard and you grew up using PC's, I recommend you install [Karabiner](https://pqrs.org/osx/karabiner/) and enable the __Use PC Style Home/End__ setting to save your sanity.

#### Xamarin Studio

An option for developinging cross platform iOS, Android, Windows and Linux.  Download and install [Xamarin Studio]().  Obtain a license.

This will also install [Mono](http://www.mono-project.com/download/) and a host of other goodies for mobile development.

#### Install Multi-Markdown Compiler

For Markdown compilation of e-mail templates, etc..:

	brew install multimarkdown

#### Install Redis

For caching of web server responses:

	brew install redis

#### Git

Next, we need to install a command line version of [Git](http://git-scm.com/) for version control.

	brew install git

Check:

	$git --version
	git version X.x.x
	
Set up your Git config with some basic stuff:

	git config --edit --global
	
Then:

```
[user]
	name = your_alias
	email = you@Application.tv
	
[core]
	editor = mate
	autocrlf = false
	
[alias]
	ad = add -A :/
	st = status
	ci = commit
	br = branch
	co = checkout
	dt = difftool
	mt = mergetool
	me = merge
	lg = log -p
	sm = submodule
	fe = fetch -v
	rm = remote
	ph = push
	pl = pull
	ss = stash
	cg = config
```
	
#### Install NodeJS

This is need for all of the web development tools:

	brew install node

Takes a little while to install as it has to compile all the _NodeJS_ source code.

#### MongoDB

Install [MongoDB](http://www.mongodb.org/) with:

	brew install mongodb --with-openssl
	
Check with:

	$mongo -version
	MongoDB shell version: 3.x.x

#### RoboMongo


	
#### Install Bower

[Bower](http://bower.io/) is used for acquiring web components.  Install with:

	npm install -g bower
	bower
	
#### Install Gulp

[Gulp](http://gulpjs.com/) is used to build the website.  Install with:

	npm install -g gulp

#### NuGet Command Line

There is a build of the [NuGet](https://www.nuget.org/) package manager for .NET that works on OSX.  This is needed for pushing libraries to [NuGet](http://nuget.net).

Clone the repo:

	cd ~/Projects
	git clone git@github.com:mrward/monodevelop-nuget-addin.git
	
Then:

	mkdir -p ~/lib/NuGet
	cp ~/Projects/monodevelop-nuget-addin/lib/* ~/lib
	edit ~/bin/nuget
	
And paste in:

	#!/bin/bash
	mono ~/lib/NuGet.exe $*

Then:

	chmod u+x ~/bin/nuget
	
#### GitHub

You need to have [SSH setup and working on GitHub](https://help.github.com/articles/generating-ssh-keys).

Create `Projects` directory and clone your repo:

	mkdir ~/Projects
	cd ~/Projects
	git clone git@github.com:username/Application.git

#### CSharpTools

Install [CSharpTools](http://github.com/jlyonsmith/CSharpTools) using:

    brew install https://gist.githubusercontent.com/jlyonsmith/8495038/raw/1da4633ebd9376b7c57f166f1b910ab226442812/csharptools.rb
    
Check the GitHub site for the most up-to-date version.  The primary tool this gives is the `vamper` tool for versioning.
	
#### Restore NuGet Packages

Use Xamarin Studio to restore all the packages for the project.

#### Building and Running the REST Service

To build the REST service:

	cd ~/Projects/Application
	xbuild Application.sln
	
If all is well, you can run the service with:

	mongod --config /usr/local/etc/mongod.conf --fork
	mono ApiService/bin/Debug/ApiService.exe
	
You should see no errors from the service log file.

#### Restore Local npm Packages

To restore the local packages for building the web site:

	cd ~/Projects/Application/Website
	npm install
	
#### Restore bower Components

To restore the components that the web site uses:

	cd ~/Projects/Application/Website
	bower install
	
#### Building and Running the Website

If `bower` and `npm` components and packages are installed correctly, you should be able to build the site with:

	cd ~/Projects/Application/Website
	gulp

Now, to run the web site type:

	gulp serve
	
Navigate to `localhost:4000` in your web browser.
