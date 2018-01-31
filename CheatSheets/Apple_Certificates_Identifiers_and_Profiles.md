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
