# Simulators

## Start iOS Simulator from the Commend Line

Use the `simctl` tool.

List available simulators with `xcrun simctl list`.

Boot an existing simulator with `xcrun simctl boot <GUID>`.

Then, open the simulator app with to the the running simulator:

```sh
open /Applications/Xcode.app/Contents/Developer/Applications/Simulator.app
```

[simctl: Control iOS Simulators from Command Line](https://medium.com/xcblog/simctl-control-ios-simulators-from-command-line-78b9006a20dc)

## Start the Android Simulator from the Command Line

Use the `emulator` tool.

To list available AVD's (Android Virtual Devices) use `emulator -list-avds`.

To start an AVD use `emulator @<AVD-NAME>`

[Starting the Emulator from the Command Line](https://developer.android.com/studio/run/emulator-commandline)