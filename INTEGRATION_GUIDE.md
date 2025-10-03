# Quick Integration Guide for Parent App

## Step 1: Update Plugin (if using from pub.dev)

```bash
flutter pub upgrade protect_app
```

## Step 2: Add to Your App

In your main app file or any screen where you want to detect screen capture:

```dart
import 'package:protect_app/protect_app.dart';
import 'dart:async';

class YourScreen extends StatefulWidget {
  @override
  _YourScreenState createState() => _YourScreenState();
}

class _YourScreenState extends State<YourScreen> {
  final _protectApp = ProtectApp();
  StreamSubscription<String>? _screenCaptureListener;

  @override
  void initState() {
    super.initState();
    _setupScreenCaptureProtection();
  }

  void _setupScreenCaptureProtection() {
    // Listen for screenshot/screen recording attempts
    _screenCaptureListener = _protectApp.onScreenCaptureDetected.listen((event) {
      _handleScreenCapture(event);
    });
  }

  void _handleScreenCapture(String captureType) {
    String title;
    String message;

    if (captureType == 'screenshot') {
      title = 'Screenshot Detected';
      message = 'Screenshots are not allowed in this app for security reasons.';
    } else if (captureType == 'screen_recording') {
      title = 'Screen Recording Detected';
      message = 'Screen recording is not allowed in this app for security reasons.';
    } else {
      return;
    }

    // Option 1: Show SnackBar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.security, color: Colors.white),
            SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red.shade700,
        duration: Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'OK',
          textColor: Colors.white,
          onPressed: () {},
        ),
      ),
    );

    // Option 2: Show Dialog (uncomment if preferred)
    // showDialog(
    //   context: context,
    //   builder: (context) => AlertDialog(
    //     title: Row(
    //       children: [
    //         Icon(Icons.warning, color: Colors.red),
    //         SizedBox(width: 8),
    //         Text(title),
    //       ],
    //     ),
    //     content: Text(message),
    //     actions: [
    //       TextButton(
    //         onPressed: () => Navigator.pop(context),
    //         child: Text('I Understand'),
    //       ),
    //     ],
    //   ),
    // );

    // Option 3: Log the event (for security audit)
    // _logSecurityEvent(captureType);
  }

  // Optional: Log security events
  // void _logSecurityEvent(String eventType) {
  //   // Send to your analytics or logging service
  //   print('Security Event: $eventType detected at ${DateTime.now()}');
  //   // analyticsService.logEvent('screen_capture_attempt', {'type': eventType});
  // }

  @override
  void dispose() {
    // IMPORTANT: Cancel the subscription to prevent memory leaks
    _screenCaptureListener?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Your Screen')),
      body: YourContent(),
    );
  }
}
```

## Step 3: Request Permissions (Android 13+ Only)

For Android 13 and above, you need to request media permissions at runtime:

### Option A: Manual Request

```dart
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

Future<void> requestMediaPermission() async {
  if (Platform.isAndroid) {
    final androidInfo = await DeviceInfoPlugin().androidInfo;
    if (androidInfo.version.sdkInt >= 33) {
      // Android 13+
      if (await Permission.photos.isDenied) {
        final status = await Permission.photos.request();
        if (status.isDenied) {
          // Handle denied permission
          print('Photos permission denied');
        }
      }
    }
  }
}

// Call this in your app initialization
@override
void initState() {
  super.initState();
  requestMediaPermission();
  _setupScreenCaptureProtection();
}
```

### Option B: Check Permission Status

```dart
Future<bool> hasMediaPermission() async {
  if (Platform.isAndroid) {
    final androidInfo = await DeviceInfoPlugin().androidInfo;
    if (androidInfo.version.sdkInt >= 33) {
      return await Permission.photos.isGranted;
    }
    return await Permission.storage.isGranted;
  }
  return true; // iOS doesn't need permission
}
```

## Step 4: Combine with Screenshot Prevention

For maximum security, combine detection with prevention:

```dart
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Prevent screenshots (where platform supports it)
  await ProtectApp().turnOffScreenshots();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ProtectedScreen(),
    );
  }
}

class ProtectedScreen extends StatefulWidget {
  @override
  _ProtectedScreenState createState() => _ProtectedScreenState();
}

class _ProtectedScreenState extends State<ProtectedScreen> {
  @override
  void initState() {
    super.initState();

    // Even with prevention, listen for attempts (as backup)
    ProtectApp().onScreenCaptureDetected.listen((event) {
      print('Screen capture blocked: $event');
      // Show error message
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(/* ... */);
  }
}
```

## Step 5: Test

### iOS Testing:

1. Run app on real iOS device
2. Take screenshot: Side Button + Volume Up
3. Start screen recording: Control Center > Screen Recording
4. Verify error messages appear

### Android Testing:

1. Run app on real Android device
2. Grant media permissions if prompted (Android 13+)
3. Take screenshot: Power + Volume Down
4. Verify error message appears within 1 second

## Common Issues & Solutions

### Issue: Android not detecting screenshots

**Solution:**

- Check permissions are granted (Android 13+)
- Test on real device, not emulator
- Verify AndroidManifest.xml has the required permissions

### Issue: iOS not detecting screen recording

**Solution:**

- Ensure device is iOS 11 or later
- Test on real device
- Verify you started screen recording, not just opened Control Center

### Issue: Memory leak warnings

**Solution:**

- Make sure you call `_screenCaptureListener?.cancel()` in `dispose()`

## Production Checklist

- [ ] Added screen capture listener to sensitive screens
- [ ] Tested on real iOS device
- [ ] Tested on real Android device (API 33+)
- [ ] Requested permissions for Android 13+
- [ ] Implemented proper cleanup in dispose()
- [ ] Customized error messages for your app
- [ ] Combined with `turnOffScreenshots()` where needed
- [ ] Tested error messages display correctly
- [ ] Considered logging security events

## Additional Features to Consider

1. **Blur Sensitive Content:**

```dart
void _handleScreenCapture(String captureType) {
  // Temporarily blur sensitive content
  setState(() => _isBlurred = true);

  // Show message
  _showSecurityMessage();

  // Remove blur after delay
  Future.delayed(Duration(seconds: 2), () {
    if (mounted) setState(() => _isBlurred = false);
  });
}
```

2. **Navigate Away from Sensitive Screen:**

```dart
void _handleScreenCapture(String captureType) {
  _showSecurityMessage();

  // Navigate back to safe screen
  Future.delayed(Duration(seconds: 1), () {
    Navigator.of(context).popUntil((route) => route.isFirst);
  });
}
```

3. **Track Multiple Attempts:**

```dart
int _captureAttempts = 0;

void _handleScreenCapture(String captureType) {
  _captureAttempts++;

  if (_captureAttempts >= 3) {
    // Log out user or take other action
    _handleExcessiveAttempts();
  } else {
    _showWarning();
  }
}
```

## Support

For detailed documentation, see:

- [SCREEN_CAPTURE_DETECTION.md](SCREEN_CAPTURE_DETECTION.md)
- [IMPLEMENTATION_SUMMARY.md](IMPLEMENTATION_SUMMARY.md)
