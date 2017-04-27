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
1. Copy `bin` directory from another project
2. Tweak the `switch_to` script as necessary
3. Copy `Gemfile` from another project
4. `rbenv local 2.2.2` in root
4. `bundle install` in root

## Artwork

1. `mkdir Xxx/Content` and linked into the app
1. `mkdir Xxx/RawContent` and put artwork, sounds, fonts, etc.. in sub-folders
1. Add Sketch file with artwork
2. Create `AppIcon.pdf` and run `create-icons`
3. Run `switch-to internal` to use internal icon

## Crashlytics/Fabric

1. Run the Fabric app
2. Add a new app
3. Paste the segment into a Run Script build phase
4. Add the initialization call
5. Run the app
6. Run `switch-to external` and do the above again
7. Run `switch-to internal`

## Do a Build

1. Regenerate provisioning profiles
1. Run an internal build and upload to Fabric