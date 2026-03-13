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

## Tools

## References

- [`appdmg`](https://www.npmjs.com/package/appdmg) for creating `.dmg` files.