## Provisioning

Apple provisioning is provides three ways to share apps:

1. **Developer releases.** You are limited sharing developer releases to 100 iPhones.  You must get a unique code from the phone and once you add it you can only remove it _once per year_.  This is not a good solution for us to use for this type of app.  You can run out of devices really quickly and Apple don't cave for special resets.
2. **Beta releases.**  You can add up to 1000 people for a limited beta release, and change that list of people at any time, but it takes up to 48 hours to get the uploaded binary approved by Apple.
3. **Enterprise releases.**  You can pay $300 per year to Apple and after an approval process get an enterprise license that lets you install your apps on an unlimited number of devices.  It’s how, for example, Uber delivers their driver app.

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

---

[QA1814]: https://developer.apple.com/library/content/qa/qa1814/_index.html
