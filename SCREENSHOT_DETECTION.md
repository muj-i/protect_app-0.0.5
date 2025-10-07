# Screenshot Detection in protect_app

This document explains how the screenshot detection feature works in the `protect_app` package.

## How It Works

### iOS Implementation

On iOS, screenshot detection uses two native system notifications:

1. `UIApplication.userDidTakeScreenshotNotification` - Detects when a user takes a screenshot
2. `UIScreen.capturedDidChangeNotification` - Detects when screen recording starts/stops

These system notifications are reliable and require no special permissions. The iOS implementation in `ScreenCaptureDetector.swift` listens for these notifications and sends events to Flutter through an EventChannel.

### Android Implementation

On Android, screenshot detection uses a `ContentObserver` to monitor changes to the MediaStore:

1. Registers a `ContentObserver` on `MediaStore.Images.Media.EXTERNAL_CONTENT_URI`
2. When a screenshot is taken, the system adds an entry to MediaStore
3. Our observer receives an `onChange` callback with the URI
4. If the URI contains keywords like "screenshot", it sends an event to Flutter

This approach has several advantages:

- No permissions required
- Works alongside `turnOffScreenshots()` (FLAG_SECURE) - can detect attempts even if blocked
- Compatible with all Android versions and manufacturers
- Minimal resource usage (just listens for system events)

## Usage in Flutter

To use screenshot detection in your Flutter app:

```dart
// Get the plugin instance
final protectApp = ProtectApp();

// Optional: Block screenshots at OS level
await protectApp.turnOffScreenshots();

// Listen for screenshot and screen recording attempts
final subscription = protectApp.onScreenCaptureDetected.listen((event) {
  if (event == 'screenshot') {
    // User attempted to take a screenshot
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Screenshot Detected'),
        content: Text('Screenshots are not allowed in this app.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  } else if (event == 'screen_recording') {
    // User started/stopped screen recording (iOS only)
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Screen Recording Detected'),
        content: Text('Screen recording is not allowed in this app.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
});

// Don't forget to cancel the subscription when done
@override
void dispose() {
  subscription.cancel();
  super.dispose();
}
```

## Important Notes

1. **Android Screenshot Blocking**: When using `turnOffScreenshots()` on Android, the OS will block the screenshot but the detection will still work. This allows you to show a custom message when a user attempts to take a screenshot.

2. **iOS Screen Recording Detection**: iOS provides reliable screen recording detection. Android does not have a similar built-in API.

3. **No Permissions Required**: Neither the iOS nor Android implementations require any special permissions.

4. **Limitations**: This approach cannot prevent a user from using another physical device to take a photo of the screen.

## Troubleshooting

If screenshot detection is not working:

1. Make sure you're testing on a real device, not an emulator/simulator
2. Check logs for "ScreenCaptureDetector" to see if events are being detected
3. Ensure your event listener is set up properly in Flutter
4. For Android, try using different screenshot methods (hardware buttons, quick settings, etc.)

## Further Improvements

Future enhancements could include:

- Detecting screen sharing on Android
- Adding more secure overlay options
- Providing callbacks for additional security measures

---

For more information, contact the maintainers or file an issue on the GitHub repository.
