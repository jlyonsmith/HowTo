# How to Manage Software Release Branches

## Introduction

Many open source software projects eschew a proper release strategy until late in their development. My recommendation is not to do this.  This article outlines a simple and effective branching strategy that makes use of basic [Git](https://git-scm.com/downloads) commands and a version number management tool or scripts. I use my [StampVer](https://github.com/jlyonsmith/stampver-rs) tool, which simply allows you to keep version information in a single place in your project, and then search/replace version numbers across various files that need the information in your source code.

## Semantic Versioning

This article assumes you are using [Semantic Versioning](https://semver.org/).  Because of semantic versioning, we agree that our version numbers are going to be formatted like so: `Major.minor.patch+build`.

## The Project States

This section talks about the three "release states" that can exist in your project, namely:

1. Pre-1.0 release, when you haven't done a public release yet.
2. Releasing a major or minor version, including the 1.0 release.
3. Doing a patch release.

Now, let's define the following rules:

1. The repo has a `main` branch that all feature work is merged into.
2. Every release must be tagged with a version number.
3. Releases come from release branches, not the `main` branch.
4. We follow semantic versioning rules for resetting minor and patch builds to zero after major or minor releases respectively.
5. You keep separate ID's, keys and other metadata for internal and external versions of your product and other special builds.  *In Flutter these are referred to as build flavors.*
6. Patch releases can come from any branch.
7. Git tags are used to indicate what code you shipped to testers and customers to so you can reproduce issues.

We won't go into `main` branch hygene, but it is in your best interests that you to keep your main branch building, with all tests passing at all times.  Don't let the bit rot set in on your `main` branch!

If your app is under active development, it's a good idea to have a public release cycle for your app.  A minor release per month is a good cadence for mobile apps, for example.

## Pre-1.0 Release

Start with a version number of `0.0.0`.  Don't update the major version until you are sure you are ready to make your first public release.

If using the [stampver](), create a `version.json5` file and set it up so that you can update all the files that contain version numbers.

In this phase only do your releases straight from the `main` branch.  Update the minor or patch number as you see fit. It's not super important because the generally accepted rule is that you can change anything without warning your users while in this state.

Generate a Git tag using `git tag -a` when you have built and tested your product. Push this tag into your `origin` repo with `git push --follow-togs`.  Move the tags as needed, but not once you have pushed to `origin`.  Instead, create a new release.

For mobile apps create an internal icon for the app to identify it as a non-release or `test` build. Create separate records in AppStoreConnect, Firebase, etc.. for this app.

## Doing Major or Minor Release

Eventually you decide you are ready to do a public release.  Test, test, test.  Then test some more.  Make sure you are ready to release!  Ensure you have added a build number to the versioning information too by appending `+` to your semantic version.

Then:

1. Update either major or minor version numbers (with `stampver -u` or other script) as the semantic versioning rules dictate based on your changes. Check these version changes into `main`.  Note, your next internal release will have this version too.
2. Create a branch that is named with the new `Major.minor` version number, *but not the patch number*.
3. On the branch, run a script to change the metadata for the product to the release values.  You can do this with `stampver` or another tool such as `flutter`.  This is generally not need for the `1.0` release as you've probably been using your production settings for testing.
4. Do a `release` build for the branch. Thi should also publish and tag the head of the branch.  If there are still bugs fix them and merge the changes to `main`, then build and tag again with a new `build` number.
5. . Again, you can use `stampver` to generate this information.

Remember, the release branch is now a unique product, with it's own versioning scheme. It just so happens that the internal product has the same version at this point, but they will soon diverge.  Be specific about whether you are using the internal or production version of the product when reporting bugs against versions numbers.

## Re-tagging

There's a big warning in the `git tag` man page about changing tags.  The summary is that if you pushed a tag, don't change it!  Your build script should see if the tag exists in the `origin`.  If not, then it can use `-f` to update it locally.  Otherwise it should fail the build and suggest you change the `patch` number before re-tagging.

## Build Flavors

Make sure you generate new bundle ID's and other data for the different build flavors.  This includes bundle ID's (iOS), app ID's (Android), service API keys, icons, display titles, etc..

Do not mix production and test data, and don't test your app in production!

## Releasing Patches

Releasing patches can happen from a the main branch or from any release branch.

In a release branch it happpens because you find bugs that _must_ be fixed before the next full release cycle. If this happens, fix the bugs in the branch or in `main`, whatever works for you or the developers. Then `git cherry-pick` the changes over to the release branch, or back to `main`.

Then, in the release branch:

1. Increment patch build number, build & test.
2. If all is well, publish and tag.

For internal releases, simply update the patch number, release and tag.  The patch number will reset when you create a new release branch.

## A Word About Revisions

Semantic versioning allows additional metadata after the patch number separated by a `-` or `+` depending on the type of data.  I use the `+` option to add a _revision number_ which is the date and a sequence number.  The sequence number allows multiple revisions in a single day.

I recommend updating the revision number right before doing the release build, as it will help you identify when a build was created. Revision numbers are mostly helpful in products with complicated build & test cycles, where builds or tests may fail and need to be repeated before release.

It's also handy if you want to do releases from the main branch, but don't want to update the patch numbers.  Make sure the revision goes into you tag descriptions.

## Other Stuff

Releasing software is not a perfect art. There will be bugs and last minute gotchas that will crop up. The approach outlined above is flexible enough to adapt to odd eventualities, but simple enough that you won't get yourself in a horrible mess.

Don't forget to encourage engineers to rebase, i.e. squash, their commits to simplify your commit logs.  Lastly, if things go horribly wrong, you can usually fix things with some interactive rebasing and merging.
