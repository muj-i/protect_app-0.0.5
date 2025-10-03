# Screen Capture Detection

This document explains how to use the screen capture detection feature in the `protect_app` plugin.

## Overview

The screen capture detection feature allows you to detect when users attempt to take screenshots or start screen recording on both iOS and Android platforms. This is useful for apps that handle sensitive information and want to notify users that such actions are not permitted.

## Features

- ✅ Screenshot detection on iOS
- ✅ Screen recording detection on iOS (iOS 11+)
- ✅ Screenshot detection on Android
- ✅ Real-time event streaming
- ✅ Easy-to-use API

## Usage

### Basic Implementation

```dart
import 'package:protect_app/protect_app.dart';
import 'dart:async';

class MyScreen extends StatefulWidget {
  @override
  _MyScreenState createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> {
  final _protectApp = ProtectApp();
  StreamSubscription<String>? _screenCaptureSubscription;

  @override
  void initState() {
    super.initState();
    _setupScreenCaptureListener();
  }

  void _setupScreenCaptureListener() {
    _screenCaptureSubscription = _protectApp.onScreenCaptureDetected.listen((event) {
      if (event == 'screenshot') {
        _showWarning('Screenshots are not allowed!');
      } else if (event == 'screen_recording') {
        _showWarning('Screen recording is not allowed!');
      }
    });
  }

  void _showWarning(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
      ),
    );
  }

  @override
  void dispose() {
    _screenCaptureSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Protected Screen')),
      body: Center(child: Text('Try taking a screenshot!')),
    );
  }
}
```

### Advanced Usage with Custom Actions

```dart
void _setupScreenCaptureListener() {
  _protectApp.onScreenCaptureDetected.listen((event) {
    switch (event) {
      case 'screenshot':
        // Log the screenshot attempt
        _logSecurityEvent('Screenshot attempt detected');

        // Show dialog instead of snackbar
        _showSecurityDialog('Screenshot Detected');

        // Optionally blur sensitive content
        _blurSensitiveContent();
        break;

      case 'screen_recording':
        // Log the screen recording attempt
        _logSecurityEvent('Screen recording detected');

        // Show warning
        _showSecurityDialog('Screen Recording Detected');

        // Optionally navigate away from sensitive screen
        Navigator.of(context).pop();
        break;
    }
  });
}

void _showSecurityDialog(String title) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text('This app does not allow screen capture for security reasons.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('OK'),
        ),
      ],
    ),
  );
}
```

## Event Types

The `onScreenCaptureDetected` stream emits the following event types:

- `"screenshot"` - User took a screenshot
- `"screen_recording"` - Screen recording started (iOS only, requires iOS 11+)

## Platform-Specific Notes

### iOS

- Screenshot detection works on all iOS versions
- Screen recording detection requires iOS 11 or later
- Uses `UIApplication.userDidTakeScreenshotNotification` and `UIScreen.capturedDidChangeNotification`

### Android

- Screenshot detection works by monitoring the MediaStore for new images
- Requires `READ_EXTERNAL_STORAGE` (SDK < 33) and `READ_MEDIA_IMAGES` (SDK >= 33) permissions
- Detection is based on file path and naming patterns (e.g., files containing "screenshot", "screen_capture")
- May have a slight delay (< 1 second) compared to iOS
- Screen recording detection is more complex on Android and is not currently supported in this implementation

## Permissions

### Android

The following permissions are automatically added to your app:

```xml
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" android:maxSdkVersion="32" />
<uses-permission android:name="android.permission.READ_MEDIA_IMAGES" />
```

**Important:** For Android 13 (API 33) and above, you need to request runtime permissions:

```dart
// Add this package to pubspec.yaml: permission_handler

import 'package:permission_handler/permission_handler.dart';

Future<void> requestPermissions() async {
  if (Platform.isAndroid) {
    if (await Permission.photos.isDenied) {
      await Permission.photos.request();
    }
  }
}
```

### iOS

No additional permissions required. The screenshot and screen recording detection works automatically.

## Combining with Screenshot Prevention

You can combine the detection listener with the existing `turnOffScreenshots()` method for maximum protection:

```dart
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Prevent screenshots from being taken (where supported)
  await ProtectApp().turnOffScreenshots();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    // Also listen for screenshot attempts (as a fallback)
    ProtectApp().onScreenCaptureDetected.listen((event) {
      // Show warning even if prevention failed
      print('Screen capture attempt: $event');
    });
  }

  // ... rest of your code
}
```

## Limitations

1. **Android Screen Recording**: The current implementation does not detect screen recording on Android. This is a complex feature that would require additional implementation.

2. **Android Screenshot Detection Accuracy**: Detection relies on file path patterns and may occasionally miss screenshots from custom camera apps or third-party screenshot tools.

3. **Permissions**: On Android 13+, users must grant photo/media permissions for screenshot detection to work.

4. **iOS Simulator**: Screenshot detection may not work reliably in the iOS Simulator.

## Best Practices

1. **Always cancel subscriptions**: Remember to cancel the stream subscription in `dispose()` to prevent memory leaks.

2. **User-friendly messages**: Use clear, non-alarming messages to inform users why screen capture is not allowed.

3. **Combine with prevention**: Use both `turnOffScreenshots()` and the detection listener for comprehensive protection.

4. **Log security events**: Consider logging screen capture attempts for security auditing purposes.

5. **Test on real devices**: Always test on physical devices, as emulators/simulators may behave differently.

## Troubleshooting

**Android: Screenshots not being detected**

- Ensure you have the required permissions in AndroidManifest.xml
- Request runtime permissions on Android 13+
- Test on a real device, not an emulator

**iOS: Screen recording not detected**

- Verify the device is running iOS 11 or later
- Test on a real device

**Stream not receiving events**

- Check that you've properly subscribed to the stream
- Ensure the subscription is active (not cancelled)
- Verify you're testing on a real device

## Example

See the complete example in the `example` folder of this package for a full working implementation.
