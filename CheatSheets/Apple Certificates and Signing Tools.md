## Summary

Apple uses 5 different signing certificates.  Each certificate serves a different purpose and include code signing and app distribution.
## Certificates

Confusingly, Apple uses a different name for the certificate in Xcode and on the command line.   Certificates are associated with an organization, or **team** as Apple refers to it.  Certificates are also sometimes referred to as **identities** by Apple.

The table below defines the different certificate types, names and where they can be used:

| Name in Xcode                        | Name in `security` Tool                                    | Can Sign Code? |
| ------------------------------------ | ---------------------------------------------------------- | -------------- |
| _Computer Name_                      | Apple Development: *User Name* (*User ID*)                 | Yes            |
| Apple Distribution                   | Apple Distribution: *Team Name* (*Team ID*)                | Yes            |
| Mac Installer Distribution           | 3rd Party Mac Developer Installer: *Team Name* (*Team ID*) | No             |
| Developer ID Application Certificate | Developer ID Application: *Team Name* (*Team ID*)          | No             |
| Developer ID Installer               | Developer ID Installer: *Team Name* (*Team ID*)            | No             |
To list certificates on the command line do `security find-identity -v`.  This will also give a UID for each of the certificates.

## Gatekeeper

macOS has a system called Gatekeeper that checks apps when they are opened.  A warning message is displayed to recommend the user not run the app.  To avoid this message, you must notarize your app using Apples tooling and your developer account, either personal or team.
## Tools

| Tool Binary                                      | Description                                                    |
| ------------------------------------------------ | -------------------------------------------------------------- |
| [`appdmg`](https://www.npmjs.com/package/appdmg) | Generates DMG files                                            |
| `security`                                       | Built-in macOS tool for manipulating keychain and certificates |
| `spctl`                                          | Security assessment tool (used to check )                      |
| `codesign`                                       | Built-in Apple tool for signing apps, packages and IPA's       |
| `ditto`                                          | Tool for copying files and keeping special Apple attributes    |
| `xcrun stapler`                                  | Tool for stapling notarizations to apps                        |
| `xcrun notarytool`                               | Tool for notarizing files                                      |
##  Creating DMG's

DMG files (`.dmg`) are the simplest way to distribute apps on macOS.  You only need to use packages (`.pkg`) if you special installation requirements, such as installing drivers.

> If you are building a [Flutter]() desktop app, you first need to go into Xcode and ensure that there is a bund build the `.app` file with  `flutter build macos`. 
1. 

## References

- [`appdmg`](https://www.npmjs.com/package/appdmg) for creating `.dmg` files.
- [Packaging and Distributing Flutter Desktop Apps](https://medium.com/@fluttergems/packaging-and-distributing-flutter-desktop-apps-the-missing-guide-part-1-macos-b36438269285)