# How to Manage Software Releases

## Introduction

Many open source software projects eschew a proper release strategy until late in their development. My recommendation is not to do this.  This document outlines a simple and effective branching strategy that makes use of basic [Git](https://git-scm.com/downloads) commands and a version number management tool or scripts. I use my [StampVer](https://github.com/jlyonsmith/stampver-rs) tool, which simply allows you to keep version information in a single place in your project, and then search/replace version numbers across various files that need the information in your source code.  Finally, this document assumes you are using [Semantic Versioning](https://semver.org/).

## The Project States

This section talks about the three release states that can exist in your project, namely:

1. Pre-1.0 release, product is under development.
2. Releasing a major or minor version, including the 1.0 release.
3. Doing a patch release.

Given that a version number is made up of `Major.minor.patch+revision`, we assume the following:

- The repo has a `main` branch that all feature work is merged into.
- That major and minor releases only happen from branches, with an initial patch number of `0`.
- You keep separate ID's, keys and other metadata for internal and external versions of your product
- Patch releases can come from any branch.
- Git tags are used to indicate _what code you shipped to testers and customers._

We won't go into `main` branch hygene, but it is in your best interests that you to keep your main branch building, with all tests passing _at all times._  Don't let the rot set in on your `main` branch!

If your app is under active development, it's a good idea to have a release cycle for your app.  A minor release per month is a good cadence for mobile apps, for example.

## Pre-1.0 Release

Start with a version number of `0.0.0`.  Don't update the major version until you are _sure_ you are ready to begin following the semantic versioning rules for your product and stabilize the functionality.

Create a `version.json5` file and set it up so that you can update all the files that contain version numbers.

Do releases straight from the `main` branch.  Update the minor or patch number as you see fit. It's not super important because the rule is you can change anything without warning while in this state.

Generate a _lightweight_ Git tag using `git tag -a` when you have built and tested your product. Push this tag into your `origin` repo with `git push --follow-togs`.  Use _annotated_ tags if you need the extra meta data.  Move the tags as needed, but not once you have pushed to `origin`.  Instead, do a new release.

For mobile apps create an internal icon for the app to identify it as a non-release or `test` build. Create separate records in AppStoreConnect, Firebase, etc.. for this app.

## Doing Major or Minor Release

Eventually you decide you are ready to do a release, including the 1.0 release. When you do the 1.0 release, make sure you generate new ID's and metadata for the release app, and continue to do so as you add new service integrations to your app. _Do not mix production and test data, and don't test your app in production!_

Here is what you need to do next:

1. Update the version numbers with `stampver` or script, either major or minor, as the semantic versioning rules dictate based on you changes.  Check those changes into `main`.  That will go on to be the base version for your next internal releases.
2. Create a branch that is named with the new `Major.minor` version number, _but not the patch number._
3. Run a script to change the metadata for the product to the release values.  You can do this with `stampver`
4. I recommend you update the _revision_ number in the branch at this point as well (see below)
5. Build and run tests for this code. If there are bugs in this first release, fix them in mainline, delete the branch and try again.
6. If all is well, do a release build, publish and tag the head of the release branch. Again, you can use `stampver` to generate this information.

> Remember, the release branch is now a separate product, with it's own versioning scheme. It just so happens that the internal product has the same version at this point, but they can and may digress.  Be specific about whether you are using the internal or production version of the product when reporting bugs against versions.

## Release Patches

Releasing patches can happen from a the main branch or from a release branch.

In a release branch it happpens because you find bugs that _must_ be fixed before the next full release cycle. If this happens, fix the bugs in the branch or in `main`, whatever works for you or the developers. Then `git cherry-pick` the changes over to the release branch, or back to `main`.

Then, in the release branch:

1. Increment patch build number, build & test.
2. If all is well, publish and tag.

For internal releases, simply update the patch number, release and tag.  The patch number will reset when you create a new release branch.

## A Word About Revisions

Semantic versioning allows additional metadata after the patch number separated by a `-` or `+` depending on the type of data.  I use the `+` option to add a _revision number_ which is the date and a sequence number.  The sequence number allows multiple revisions in a single day.

I recommend updating the revision number right before doing the release build, as it will help you identify when a build was created. Revision numbers are mostly helpful in complex products with complicated build & test cycles, where builds or tests may fail and need to be repeated before release.

It's also handy if you want to do releases from the main branch, but don't want to update the patch numbers.  Make sure the revision goes into you tag descriptions.

## Other Stuff

Releasing software is not a perfect art. There will be bugs and last minute gotchas that will crop up. The approach outlined above is flexible enough to adapt to odd eventualities, but simple enough that you won't get yourself in a horrible mess.

Don't forget to encourage engineers to rebase their commits to simplify your commit logs. Lastly, if things go horribly wrong, you can usually fix things with some interactive rebasing and merging.
