import 'package:flutter/material.dart';
import 'dart:async';

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
  @override
  void initState() {
    super.initState();
    initPlatformState();
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
            ],
          ),
        ),
      ),
    );
  }
}
