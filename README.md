# Protect App Flutter Plugin

A Flutter plugin designed to enhance the security of your Flutter applications by providing features to detect and mitigate potential security risks on the device. This plugin allows you to:

- Turn off screenshots to prevent sensitive information from being captured.
- **Detect screenshot and screen recording attempts in real-time** ⭐ NEW!
- Detect if the device is using a VPN.
- Check if the device is jailbroken or rooted.
- Verify if the developer mode is turned on.
- Retrieve data about the current proxy settings on the device.

## Features

- **Turn Off Screenshots**: Prevent users from taking screenshots within your app to protect sensitive information.

```dart
await ProtectApp().turnOffScreenshots();
```

- **Screenshot/Screen Recording Detection** ⭐ NEW!: Get notified in real-time when users attempt to take screenshots or start screen recording.

```dart
ProtectApp().onScreenCaptureDetected.listen((event) {
  if (event == 'screenshot') {
    // Show warning message
  } else if (event == 'screen_recording') {
    // Show warning message
  }
});
```

📖 [See detailed documentation](SCREEN_CAPTURE_DETECTION.md)

- **VPN Detection**: Detect if the device is currently using a VPN.

```dart
await ProtectApp().isDeviceUseVPN();
```

- **Jailbroken/Rooted Device Detection**: Check if the device is jailbroken (iOS) or rooted (Android).

```dart
await ProtectApp().isUseJailBrokenOrRoot();
```

- **Developer Mode Detection**: Verify if the developer mode is turned on.

```dart
await ProtectApp().checkIsTheDeveloperModeOn();
```

- **Proxy Data Retrieval**: Retrieve information about the current proxy settings on the device.

```dart
await ProtectApp().dataOfCurrentProxy();
```

- **Real Device Detection**: Detect if the device is real or not.

```dart
await ProtectApp().isItRealDevice();
```

- **Run on testflight**: Detect if the app is running in the testflight.

```dart
await ProtectApp().isRunningInTestFlight();
```

## Installation

Run this command:

```yaml
flutter pub add protect_app
```
