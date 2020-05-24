# Certificates, Identifiers &amp; Profiles

## Overview

Apple provisioning provides four ways to share apps:

1. **Developer releases** You are limited sharing developer releases to 100 iPhones. You must get a unique code from the phone and once you add it you can only remove it _once per year_. You can run out of devices really quickly and Apple don't cave for special resets. _Only use for your developers, testers, artists and program managers._
2. **Beta releases** You can add up to 1000 people for a limited TestFlight Beta release, and change that list of people at any time, but it takes up to 48 hours to get the uploaded binary approved by Apple.
3. **App store releases** Once an app can be submitted to the app store with a multi-day approval process. This app can be a version that was released as a TestFlight Beta or directly submitted.
4. **Enterprise releases** You can pay \$300 per year to Apple and after an approval process get an enterprise license that lets you install your apps on an unlimited number of devices. It’s how, for example, Uber delivers their driver app.

Before you can create provisioning profiles you need:

- Device UDIDs
- Certificates

Here's how to get them.

## Getting a Device UDID

The UDID is not visible on the phone. It has to be revealed in iTunes, and it cannot be highlighted and copied like normal text. To retrieve the UDID you would need to do the following:

1. Connect the device to the computer, and run iTunes.
2. Select the device in the Device list. On the right side the device information will be visible.
3. Click the Serial Number. It will switch to displaying the UDID.
4. Press **&#8984;C** to copy the UDID to the clipboard.

The site [What's my UDID?](http://whatsmyudid.com/) has a nice walk through.

## Certificates

There are two categories of certicate; **development** and **production** (also referred to as **distribution** in Xcode).

Development certificates for iOS development allow you to debug apps with Xcode and they are managed by Xcode. There are also sandbox Apple Push Notification certificates which you manage yourself. Production certificates are for distribution and push notifications, and are created using a signing request.

### The Easy Way

To generate a certificate the easy way, just use the Xcode 9 Accounts dialog. Go here and sign-in to the your Apple Developer account:

![Xcode Accounts](Apple_Code_Signing/xcode-accounts.png)

Click on the `+` button at the bottom of the account dialog and select _iOS Development_ or _iOS Distribution_:

![Xcode Generate Certificates](Apple_Code_Signing/xcode-accounts-certs.png)

This will also put the certificate in the Keychain Access application, and do all the other magical stuff below to give the `codesign` tool access, etc..

Now, turn on automatic code signing:

![Xcode Automatic Signing](Apple_Code_Signing/xcode-automatic-signing.png)

That's all you need to do for local development

### The Hard Way

Just for fun, heres what you need to do to generate a certificate manually.

- In the Applications folder on your Mac, open the Utilities folder and launch Keychain Access.
- Within the Keychain Access drop down menu, select _Keychain Access > Certificate Assistant > Request a Certificate from a Certificate Authority_.
  - In the Certificate Information window, enter the following information
    - In the User Email Address field, your (development) or the company (production) email address.
    - In the Common Name field put the thing you are generating the certificate for, e.g. _Company Name_ or _App Name APN_.
    - The CA Email Address field should be left empty.
    - In the "Request is" group, select the "Saved to disk" option.
- Click Continue within Keychain Access to complete the CSR generating process.
- Download the certificate straight away from the developer portal and drag into the Keychain Access app.
- Email should be that of the Apple user generating the certificate.

You'll need to manually move both the certificate and the generated private key around to any machine that needs to build production packages. Do this by exporting a `.p12` file from `Keychain Access.app`.

- After the first download, the _Download_ button in the developer portal only brings down the certificate and not the private key.
- Make sure the private key shows as a child of the certificate in _Keychain Access_.
- The certificate needs to be on the **login** keychain.
- When exporting, make sure to expand the certificate and select both the certificate and the private key.
- You can leave the password blank but _don't_, just use something easy to type.
- Give the `codesign` tool access to the private key by going to **Get Info** and `+` then **Shift+&#8984;+G**, paste in `/usr/bin/codesign` then **Add**, **Save** &amp; type admin password.
- Import `.p12` files by double-click. Drag/drop into **Keychain Access** is unreliable.
- Check the certificate shows up without an error icon in **Xcode** under **Preferences Accounts**.

So, yeah. Use automatic code signing.

## Provisioning

Provisioning profiles contain a cryptographically signed collection of:

- An app ID
- A team ID
- One or more certificates (usually developer and team)
- A list of devices (ad-hoc and developer profiles only)
- A list of capabilities
- A list of entitlements

It's installed on the device to allow an app to run on that device. It can be installed separatedly for ad-hoc releases, or bundled with the app for production releases.

**Ad-Hoc Distribution:** Distribution builds of an app, which can be installed on 100 devices designated by the developer on his provisioning portal. The distribution mechanism can be websites, mails or OTA. These type of builds are generally for beta testing or demos.

**App-store Distribution:** Distribution builds that are intended for general public(for sale). The distribution mechanism is iTunesConnect and the APp store only. This is also the profile you want to use for TestFlight distribution.

### Identifying Xcode Managed Provisioning Profiles

Xcode-managed provisioning profiles in the member center using an explicit App ID begin with the `iOS Team Provisioning Profile:` and are followed by the bundle ID.

The name of a distribution provisioning profile begins with the text `XC:` followed by the App ID.

If you are using a wildcard App ID, the name of the distribution provisioning profile is `XC:*`.

See [QA1814].

---

[qa1814]: https://developer.apple.com/library/content/qa/qa1814/_index.html
