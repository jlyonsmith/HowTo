# Build React Native Android APK

## Create release `.keystore`

You need to create a keystore for building a releasing version of the app.  You will put this in your `~/.android` directory _not_ in your project tree.

```
cd ~/.android
keytool -genkey -v -keystore <app-id>.keystore -alias <company-alias> -keyalg RSA -keysize 2048 -validity 10000
```

Answers to the questions might look like:

```
Enter keystore password:
Re-enter new password:
What is your first and last name?
  [Unknown]:  admin@yourdomain.com
What is the name of your organizational unit?
  [Unknown]:
What is the name of your organization?
  [Unknown]:  Your Company LLC
What is the name of your City or Locality?
  [Unknown]:  New York
What is the name of your State or Province?
  [Unknown]:  New York
What is the two-letter country code for this unit?
  [Unknown]:  US
Is CN=admin@yourdomain, OU=Unknown, O=Your Company LLC, L=New York, ST=New York, C=US correct?
  [no]:  yes
```

There doesn't seem any harm in following the recommendation to convert the keystore to PKCS12 format either:

```
keytool -importkeystore -srckeystore <app-id>.keystore -destkeystore <app-id>.keystore -deststoretype pkcs12
```

Upload the `.keystore` file plus filename, alias, password, generated date, validity days and if the file was converted to PKCS12 format to a secure secret storage tool like LastPass.

## Add Global Gradle Properties

Open the file `~/.gradle/gradle.properties` and add:

```
<APP_ID>_PROJECT_RELEASE_STORE_FILE=/Users/<your-alias>/.android/<app-id>.keystore
<APP_ID>_PROJECT_RELEASE_KEY_ALIAS=<alias>
<APP_ID>_PROJECT_RELEASE_STORE_PASSWORD=<password>
<APP_ID>_PROJECT_RELEASE_KEY_PASSWORD=<password>
```

Open the file `./android/app/build.gradle` and add a section:

```
...
defaultConfig {
  ...
}
signingConfigs {
    release {
        storeFile file(<APP_ID>_PROJECT_RELEASE_STORE_FILE)
        storePassword <APP_ID>_PROJECT_RELEASE_STORE_PASSWORD
        keyAlias <APP_ID>_PROJECT_RELEASE_KEY_ALIAS
        keyPassword <APP_ID>_PROJECT_RELEASE_KEY_PASSWORD
    }
    ...
    buildTypes {
        release {
          ...
          signingConfig signingConfigs.release
        }
    }
}
...
```

## Building the APK

Ensure that your app has a versioning scheme in place, like [stampver](https://www.npmjs.com/package/stampver).

Update the `AndroidManifest.xml` file:

```
    android:versionCode="1"
    android:versionName="1.0">
```

`versionCode` should be monotonically increasing with each release, up to the value 2100000000.  `versionName` should be a <major>.<minor> version number.  See [Android app versioning](https://developer.android.com/studio/publish/versioning.html).

Run:

```
cd android
./gradlew assembleRelease
```

The `.apk` is in the `android/app/build/outputs/apk/` folder.

