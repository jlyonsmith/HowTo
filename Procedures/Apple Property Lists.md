## Overview

Apple uses PList files with a `.plist` extension to store application configuration.  They can be in a range of formats, including binary and XML.  Most common in 2026 is binary.

## CLI Manipulation

Create a `.plist` with `plist -create binary1 MyProps.plist`.

Add to binary `.plist` value with `plist -insert KeyName -bool NO MyProps.plist`
