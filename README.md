# Heat Generator

A pocket warmer for cold times.
Heat up your device.
Keep your hands warm.
This app uses the CPU / Processor to heat up the device.

[PRIVACY POLICY](PROVACY_POLICY.md)

### Environment

* IntelliJ IDEA
* Android Studio
* Flutter
* Java

### iOS Release

> **Note**
> Apple Review got rejects this app cause of: "Please remove any feature that may result in damaging the user’s
> device." I wonder why iOS Games gets accepted...

1) Folder \[APP ROOT FOLDER\]: `flutter build ipa --obfuscate --split-debug-info --build-number=1.0.0+4`
2) Install and open the Apple [Transport macOS app](https://apps.apple.com/us/app/transporter/id1450874784). Drag and
   drop the build/ios/ipa/*.ipa app bundle into the app. and click on Deliver`

### Android Release

> **Note**
> Google Review got rejects this app cause of: "Reflections on you ID card" - well the reflections are security signs on
> german ID Cards

1) Folder \[android\]: `flutter build appbundle`
2) Open in Browser [Google Play Console](https://play.google.com/console)
3) Create a new release with the generated file `build/app/outputs/bundle/release/app-release.aab`

![iphone screenshot](assets/iphone_screenshot.png "Screenshot iphone")

## Flutter Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
