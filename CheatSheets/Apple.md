# Certificates, Identifiers &amp; Profiles

# General

Apple provisioning provides four ways to share apps:

1. **Developer releases** You are limited sharing developer releases to 100 iPhones.  You must get a unique code from the phone and once you add it you can only remove it _once per year_.  You can run out of devices really quickly and Apple don't cave for special resets.  _Only use for your developers, testers, artists and program managers._
2. **Beta releases**  You can add up to 1000 people for a limited TestFlight Beta release, and change that list of people at any time, but it takes up to 48 hours to get the uploaded binary approved by Apple.
3. **App store releases**  Once an app can be submitted to the app store with a multi-day approval process.  This app can be a version that was released as a TestFlight Beta or directly submitted.
4. **Enterprise releases**  You can pay $300 per year to Apple and after an approval process get an enterprise license that lets you install your apps on an unlimited number of devices.  It’s how, for example, Uber delivers their driver app.

## Getting UDID

The UDID is not visible on the phone. It has to be revealed in iTunes, and it cannot be highlighted and copied like normal text. To retrieve the UDID you would need to do the following:

1. Connect the device to the computer, and run iTunes. 
2. Select the device in the Device list. On the right side the device information will be visible.
3. Click the Serial Number. It will switch to displaying the UDID. 
4. Press **&#8984;C** to copy the UDID to the clipboard.

## Identifying Xcode-managed Provisioning Profiles

Xcode-managed provisioning profiles in the member center using an explicit App ID begin with the `iOS Team Provisioning Profile:` and are followed by the bundle ID. 

The name of a distribution provisioning profile begins with the text `XC:` followed by the App ID. 

If you are using a wildcard App ID, the name of the distribution provisioning profile is `XC:*`.

See [QA1814].

## Certificates

There are two types of certifate; developer and production.  Developer certificates are managed by Xcode.  As of Xcode 9 a certificate is generated for each computer the developer logs in on.  

Production certificates are created using a signing request, following the instructions given in the developer portal.  You'll need to manually move both the certificate and the generated private key around to any machine that needs to build production packages.  Do this by exporting a `.p12` file from `Keychain Access.app`.  Ignore the _Download_ button in the developer portal as it only downloads the certificate and not the private key.  Make sure the private key shows as a child of the certificate in _Keychain Access_.  This certificate needs to be on the **login** keychain.



---

[QA1814]: https://developer.apple.com/library/content/qa/qa1814/_index.html
