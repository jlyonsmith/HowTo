# Flutter Project Setup

## Customize Lints

Add to  `analysis_options.yaml`:

```yaml
  rules:
    prefer_relative_imports: true
    prefer_single_quotes: true
    avoid_print: false
```

## Icons

Use [Icons_Launcher](https://pub.dev/packages/icons_launcher).  Follow the instructions on the pub.dev page.

Create a `dev_assets/` folder. Put an `appicon.png` there.  Add this to `pubspec.yaml`:

```yaml
flutter_icons:
  android: true
  ios: true
  image_path: "dev_assets/icon/appicon.png"
  adaptive_icon_background: "#191919"
  adaptive_icon_foreground: "dev_assets/appicon-adaptive.png"
```

Picking your own background/foreground colors/images.

Run `flutter pub run icons_launcher:main`.

See [Adaptive Icons](https://developer.android.com/guide/practices/ui_guidelines/icon_design_adaptive) for more information on Android adaptive icons. Also, see this series of Medium articles

- [Understanding Android Adaptive Icons | by Nick Butcher | Google Design | Medium](https://medium.com/google-design/understanding-android-adaptive-icons-cee8a9de93e2)
- [Designing Adaptive Icons. Android O introduces a new app icon… | by Nick Butcher | Google Design | Medium](https://medium.com/google-design/designing-adaptive-icons-515af294c783)

Here are some adaptive icon test tools:

- [Adaptive Icon test](https://adaptiveicon.com/)

## Splash Screen

Android icon and splash assets are under `android/app/src/main/res/`.

Edit the `**/launch_background.xml` files and add:

```xml
<item>
  <bitmap android:gravity="center" android:src="@drawable/splash_icon" />
</item>
```

See [Adding Icons & Splash Screens](https://www.udemy.com/course/learn-flutter-dart-to-build-ios-android-apps/learn/lecture/15229810#search) for more info.
