import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:protect_app/protect_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ProtectApp().turnOffScreenshots();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _protectAppPlugin = ProtectApp();

  bool isDeviceUseVPN = false;
  bool isUseJailBrokenOrRoot = false;
  bool isRunOnTestFlight = false;
  bool isDeviceUseTurnOnTheDeveloperMode = false;
  bool isDeviceIsReal = false;
  Map dataOfProxyDeviceUse = {};
  StreamSubscription<String>? _screenCaptureSubscription;
  String _lastCaptureEvent = 'No capture detected yet';

  @override
  void initState() {
    super.initState();
    initPlatformState();
    _setupScreenCaptureListener();
  }

  /// Set up listener for screenshot and screen recording detection
  void _setupScreenCaptureListener() {
    _screenCaptureSubscription =
        _protectAppPlugin.onScreenCaptureDetected.listen((event) {
      setState(() {
        _lastCaptureEvent = event;
      });

      // Show error message to user
      if (mounted) {
        final message = event == 'screenshot'
            ? '⚠️ Screenshots are not allowed in this app!'
            : '⚠️ Screen recording is not allowed in this app!';

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _screenCaptureSubscription?.cancel();
    super.dispose();
  }

  Future<void> initPlatformState() async {
    try {
      bool tempIsDeviceUseVPN =
          await _protectAppPlugin.isDeviceUseVPN() ?? false;
      bool tempIsRunOnTestFlight =
          await _protectAppPlugin.isRunningInTestFlight() ?? false;
      bool tempIsDeviceIsReal =
          await _protectAppPlugin.isItRealDevice() ?? false;
      bool tempIsUseJailBrokenOrRoot =
          await _protectAppPlugin.isUseJailBrokenOrRoot() ?? false;
      bool checkIsTheDeveloperModeOn =
          await _protectAppPlugin.checkIsTheDeveloperModeOn() ?? false;
      Map dataOfCurrentProxy =
          await _protectAppPlugin.dataOfCurrentProxy() ?? {};
      setState(() {
        isDeviceUseVPN = tempIsDeviceUseVPN;
        isRunOnTestFlight = tempIsRunOnTestFlight;
        isUseJailBrokenOrRoot = tempIsUseJailBrokenOrRoot;
        isDeviceIsReal = tempIsDeviceIsReal;
        isDeviceUseTurnOnTheDeveloperMode = checkIsTheDeveloperModeOn;
        dataOfProxyDeviceUse = dataOfCurrentProxy;
      });
    } on PlatformException {}
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            children: [
              Text('is the device use vpn:$isDeviceUseVPN'),
              Text(
                  'is the device use jailBroken or root:$isUseJailBrokenOrRoot'),
              Text(
                  'is the device use turn on the developer mode:$isDeviceUseTurnOnTheDeveloperMode'),
              Text('data of the proxy use:$dataOfProxyDeviceUse'),
              Text('is the device is real:$isDeviceIsReal'),
              Text('is the app on the testflight.:$isRunOnTestFlight'),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue),
                ),
                child: Column(
                  children: [
                    const Text(
                      '🔒 Screen Capture Detection',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('Last event: $_lastCaptureEvent'),
                    const SizedBox(height: 8),
                    const Text(
                      'Try taking a screenshot or recording!',
                      style:
                          TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
