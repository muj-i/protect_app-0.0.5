# Screen Capture Detection - Implementation Summary

## What Was Added

A complete screen capture detection system for both iOS and Android that allows your app to detect when users attempt to take screenshots or start screen recording.

## Files Modified/Created

### Dart Files (Flutter Interface)

1. **lib/protect_app.dart** - Added `onScreenCaptureDetected` getter
2. **lib/protect_app_platform_interface.dart** - Added stream interface
3. **lib/protect_app_method_channel.dart** - Implemented EventChannel for streaming events

### iOS Files

1. **ios/Classes/ScreenCaptureDetector.swift** - NEW FILE

   - Detects screenshots using `UIApplication.userDidTakeScreenshotNotification`
   - Detects screen recording using `UIScreen.capturedDidChangeNotification` (iOS 11+)
   - Implements `FlutterStreamHandler` for event streaming

2. **ios/Classes/ProtectAppPlugin.swift** - MODIFIED
   - Registered EventChannel for screen capture events
   - Initialized ScreenCaptureDetector

### Android Files

1. **android/src/main/kotlin/com/app/protect_app/ScreenCaptureDetector.kt** - NEW FILE

   - Monitors MediaStore for new images using ContentObserver
   - Detects screenshots by checking file paths and names for screenshot-related keywords
   - Implements EventChannel.StreamHandler

2. **android/src/main/kotlin/com/app/protect_app/ProtectAppPlugin.kt** - MODIFIED

   - Registered EventChannel for screen capture events
   - Manages ScreenCaptureDetector lifecycle
   - Updates detector when activity changes

3. **android/src/main/AndroidManifest.xml** - MODIFIED
   - Added READ_EXTERNAL_STORAGE permission (for Android < 13)
   - Added READ_MEDIA_IMAGES permission (for Android 13+)

### Documentation

1. **SCREEN_CAPTURE_DETECTION.md** - NEW FILE

   - Complete usage guide
   - Platform-specific notes
   - Best practices
   - Troubleshooting

2. **README.md** - MODIFIED
   - Added new feature to the features list
   - Linked to detailed documentation

### Example

1. **example/lib/main.dart** - MODIFIED
   - Added listener setup in initState
   - Shows SnackBar when screen capture is detected
   - Displays last capture event in UI
   - Proper cleanup in dispose

## How It Works

### iOS Implementation

- Uses iOS NotificationCenter to listen for system notifications
- `UIApplication.userDidTakeScreenshotNotification` triggers when screenshot is taken
- `UIScreen.capturedDidChangeNotification` triggers when screen recording starts (iOS 11+)
- Events are immediately sent to Flutter via EventChannel

### Android Implementation

- Registers ContentObserver on MediaStore.Images.Media.EXTERNAL_CONTENT_URI
- When a new image is added, checks if it's a screenshot by:
  - Verifying it was created within the last 2 seconds
  - Checking if the filename or path contains screenshot-related keywords
- Sends event to Flutter via EventChannel

## Usage Example

```dart
import 'package:protect_app/protect_app.dart';
import 'dart:async';

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  StreamSubscription<String>? _subscription;

  @override
  void initState() {
    super.initState();

    // Start listening for screen capture events
    _subscription = ProtectApp().onScreenCaptureDetected.listen((event) {
      String message;
      if (event == 'screenshot') {
        message = '⚠️ Screenshots are not allowed!';
      } else if (event == 'screen_recording') {
        message = '⚠️ Screen recording is not allowed!';
      } else {
        return;
      }

      // Show error message to user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    });
  }

  @override
  void dispose() {
    _subscription?.cancel(); // Important: prevent memory leaks
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Protected App')),
        body: Center(
          child: Text('Try taking a screenshot!'),
        ),
      ),
    );
  }
}
```

## Event Types

The stream emits these string values:

- `"screenshot"` - User took a screenshot
- `"screen_recording"` - Screen recording started (iOS only)

## Permissions Required

### Android

```xml
<!-- For Android 12 and below -->
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" android:maxSdkVersion="32" />

<!-- For Android 13 and above -->
<uses-permission android:name="android.permission.READ_MEDIA_IMAGES" />
```

**Note:** On Android 13+, you need to request runtime permission for photos/media.

### iOS

No additional permissions required - works out of the box.

## Testing

1. **iOS Testing:**

   - Take a screenshot: Press Side Button + Volume Up (or Home + Power on older devices)
   - Start screen recording: Control Center > Screen Recording
   - Should see "screenshot" event immediately
   - Should see "screen_recording" event when recording starts

2. **Android Testing:**
   - Take a screenshot: Power + Volume Down
   - Should see "screenshot" event within ~1 second
   - Make sure to grant photo/media permissions on Android 13+

## Limitations

1. **Android Screen Recording**: Not currently detected (would require additional MediaProjection monitoring)
2. **Android Detection Accuracy**: Based on file path patterns, may miss screenshots from some third-party apps
3. **Permissions**: Android 13+ requires runtime permission for media access
4. **Timing**: Android detection may have slight delay (< 1 second) due to ContentObserver

## Best Practices

1. ✅ Always cancel stream subscription in `dispose()`
2. ✅ Combine with `turnOffScreenshots()` for maximum protection
3. ✅ Show user-friendly, non-alarming messages
4. ✅ Test on real devices, not emulators
5. ✅ Consider logging security events for audit purposes

## Future Enhancements

Potential improvements for future versions:

- Android screen recording detection using MediaProjection
- More robust Android screenshot detection
- Option to automatically blur screen content when screen capture is detected
- Analytics/logging integration
- Customizable detection sensitivity

## Support

For detailed documentation, see [SCREEN_CAPTURE_DETECTION.md](SCREEN_CAPTURE_DETECTION.md)
