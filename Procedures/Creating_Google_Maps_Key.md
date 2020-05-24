# Creating Google Maps Keys

To use Google maps in an app you need to create a Google Maps API key.  Create a separate key for iOS and Android apps.

## iOS 

*NOTE:* You can only use Google Maps for free in a public app.  A private app costs at least $10K per year.  Better to use Apple maps data.

Go to the [Google API Console](https://console.developers.google.com/flows/enableapi?apiid=maps_android_backend).  Create a new project, the select _Credentials_ on the left.  _Create Credentials > API Key_  Pick _Application Restrictions > iOS_ then add the bundle identifier for your application.  

Click _Save_ and you can now use the key in your app.  You must pass it into the Google Maps SDK in the `AppDelegate.m` (or Swift equivalent):

```
[GMSServices provideAPIKey:@"YOUR-KEY-HERE"];
```

## Android

NOTE: Google Maps is free for Android apps.

In the [Google API Console](https://console.developers.google.com/flows/enableapi?apiid=maps_android_backend) create another API key (see above) and select _Application Restrictions > Android_.  

Run `cd ~/.android && keytool -list -v -keystore debug.keystore` to get the debug key store SHA-1 hash.  Paste that and your apps _Package Name_ from the `AndroidManifest.xml` file into the fields and _Save_.

Paste into the `AndroidManifest.xml` file:

```
<application>
  ...
  <meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="YOUR_API_KEY"/>
  ...
```

You can now use Google Maps in your application.

When you generate your distribution keystore, generate a new SHA-1 hash and add it to the list of hashes for the key, or generate a new key for distribution.
