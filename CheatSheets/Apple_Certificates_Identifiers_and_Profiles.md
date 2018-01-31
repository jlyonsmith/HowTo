# Identifying Xcode-managed Provisioning Profiles

Xcode-managed provisioning profiles in the member center using an explicit App ID begin with the `iOS Team Provisioning Profile:` and are followed by the bundle ID. 

The name of a distribution provisioning profile begins with the text `XC:` followed by the App ID. 

If you are using a wildcard App ID, the name of the distribution provisioning profile is `XC:*`.

See [QA1814].

---

[QA1814]: https://developer.apple.com/library/content/qa/qa1814/_index.html
