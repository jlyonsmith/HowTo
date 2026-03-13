## Summary

Apple uses 5 different signing certificates.  Each certificate serves a different purpose and include code signing and app distribution.

## Certificates

Confusingly, Apple uses a different name for the certificate in Xcode and on the command line.   Certificates are associated with an organization, or **team** as Apple refers to it.  

The table below defines the different certificate types, names and where they can be used:

| Name in Xcode                        | Name in `security` Tool                           |
| ------------------------------------ | ------------------------------------------------- |
| _Computer Name_                      | Apple Development: *User* (*User ID*)             |
| Apple Distribution                   | Apple Distribution: *Team* (*Team ID*)            |
| Mac Installer Distribution           |                                                   |
| Developer ID Application Certificate | Developer ID Application: *Team Name* (*Team ID*) |
| Developer ID Installer               | Developer ID Installer: *Team Name* (*Team ID*)   |
