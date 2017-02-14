# Creating a New iOS Project

## First Steps

1. `mkdir XXX`
1. `git init`
1. *File New* in Xcode
1. Copy in `.gitignore` and tweak
1. Create `README.MD`
1. `git com -am "Initial commit"`
1. `git remote add origin ...`
1. `git push -u origin master`

## Creating the Xcode Project

1. Start Xcode
1. *File > New > Workspace*
1. Save in project dir
1. *File > New > Project*
1. Select type, etc..
1. Create in project directory, add to above workspace.
1. Build & run
1. Run tests
1. `git com -am "Initial project"`
1. `git push`

## Fixing the Build

1. Xcode will create the project in an extra sub-folder. Move it down one level.
1. Fix the mess that ensues

## Adding Build Infrastructure

1. Copy `.version` and `.version.config` files in, rename and tweak
1. Copy `AppVersion.swift` file and add to project
1. `Podfile`
1. `Gemfile`
1. Copy `main.swift` from another project for unit test builds
1. 

## Artwork

1. `mkdir Xxx/Content` and linked into the app
1. `mkdir Xxx/RawContent` and put artwork, sounds, fonts, etc.. in sub-folders
1. 
