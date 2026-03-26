## Summary

Apple uses 5 different signing certificates.  Each certificate serves a different purpose and include code signing and app distribution.
## Certificates

Confusingly, Apple uses a different name for the certificate in Xcode and on the command line.   Certificates are associated with an organization, or **team** as Apple refers to it.  Certificates are also sometimes referred to as **identities** by Apple.

The table below defines the different certificate types, names and where they can be used:

| Name in Xcode                        | Name in `security` Tool                                    | Can Distribute | Can Sign Code? |
| ------------------------------------ | ---------------------------------------------------------- | -------------- | -------------- |
| _Computer Name_                      | Apple Development: *User Name* (*User ID*)                 | No             | Yes            |
| Apple Distribution                   | Apple Distribution: *Team Name* (*Team ID*)                | No             | Yes            |
| Mac Installer Distribution           | 3rd Party Mac Developer Installer: *Team Name* (*Team ID*) | Yes            | No             |
| Developer ID Application Certificate | Developer ID Application: *Team Name* (*Team ID*)          | Yes            | No             |
| Developer ID Installer               | Developer ID Installer: *Team Name* (*Team ID*)            | Yes            | No             |
To list certificates on the command line do `security find-identity -v`.  This will also give a UID for each of the certificates.

## Gatekeeper and Notarization

macOS has a system called Gatekeeper that checks apps when they are opened.  A warning message is displayed to recommend the user not run the app.  To avoid this message, you must notarize your app using Apples tooling and your developer account, either personal or team.

To notarize, you need to create an **app specific password**.  Go to https://account.apple.com, sign in and click on **App-Specific Password**.   Then run the notary tool to save the credentials, 

```bash
xcrun notarytool store-credentials $PROFILE --apple-id $USER_EMAIL --team-id $TEAM_ID
```

This will prompt for your password, the app-specific passward, and then store it in the keychain for future reference.
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

> If you are building a [Flutter]() desktop app, you first need to go into Xcode with `open macos/Runner.xcworkspace` and ensure that there is a bundle identifier and a team selected on the **Signing & Capabilities** tab.  Ensure that you have all the needed app capabilities and permissions in the `.plist` file.   Check the **Product Name** is set under **Build Settings ▶ Packaging**.
> 
> Then build the `.app` file with  `flutter build macos` each time you want to release it.

Here are steps once you have a `.app` file:

| Variable | Meaning                          |
| -------- | -------------------------------- |
| APP_FILE | The `.app` file, e.g. `Cool.app` |
| ZIP_FILE | `Cool.zip`                       |
| DMG_FILE | `Cool.dmg`                       |

1. Build the app with `flutter build macos`.
2. Sign the app with `codesign --options=runtime --force --verbose --sign "Developer ID Application: Mozayik, LLC (3Y86SR3KTD)" $APP_FILE`.  This preserves the harden runtime information, forces a re-sign, verbose output and uses the distribution certificate.
3. Create a zip file for signing with `ditto -c -k --sequesterRsrc --keepParent $APP_FILE $ZIP_FILE`.  The `ditto` tool preserves Apple specific HFS meta-data and resource-forks, as well as appending the parent directory.
4. Then notarize the ZIP file with `xcrun notarytool submit $ZIP_FILE -p $PROFILE --wait`  Once the notarization is done you will get the message `accepted` on the console.
5. Then staple the notarization to the app with `xcrun stapler staple "scratch/Odin.app"`
6. Finally, build the `.dmg` with `appdmg appdmg.json $DMG_FILE`

## Creating PKG's

`.pkg` files are an advanced way to install apps on macOS.  Because `.pkg` files have metadata, MDM solutions can do a better job of tracking versioning information and automatically updating programs.

1. Build the app with `flutter build macos`
2. Sign the app with `codesign --options=runtime --force --verbose --sign "Developer ID Application: Mozayik, LLC (3Y86SR3KTD)" $APP_FILE`.  This preserves the harden runtime information, forces a re-sign, verbose output and uses the distribution certificate.
3. Build the package `xcrun productbuild --component "build/macos/Build/Products/Release/Odin.app" /Applications scratch/Odin-unsigned.pkg`
4. Sign the package `xcrun productsign --sign "Developer ID Installer: Mozayik, LLC (3Y86SR3KTD)" scratch/Odin-unsigned.pkg scratch/Odin.pkg`.
5. Submit for notarization `xcrun notarytool submit scratch/Odin.pkg -p Mozayik --wait`.
6. Check the notarized package is good to install ``.
## References

- [`appdmg`](https://www.npmjs.com/package/appdmg) for creating `.dmg` files.
- [Packaging and Distributing Flutter Desktop Apps](https://medium.com/@fluttergems/packaging-and-distributing-flutter-desktop-apps-the-missing-guide-part-1-macos-b36438269285)
- [How to Build DMG and PKG from Flutter Apps](https://gist.github.com/IsmailAlamKhan/c13fde81044ac8930f328b98272e9d97)
