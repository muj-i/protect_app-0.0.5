import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'protect_app_platform_interface.dart';

/// An implementation of [ProtectAppPlatform] that uses method channels to interact with the native platform.
class MethodChannelProtectApp extends ProtectAppPlatform {
  /// The method channel used to interact with the native platform.
  /// This channel is used to invoke methods on the native side.
  @visibleForTesting
  final methodChannel = const MethodChannel('protect_app');

  /// The event channel used to listen for screen capture events.
  @visibleForTesting
  final eventChannel = const EventChannel('protect_app/screen_capture');

  /// Checks if the device is currently using a VPN.
  /// Returns a [bool] indicating whether the device is using a VPN.
  @override
  Future<bool?> isDeviceUseVPN() async {
    final version = await methodChannel.invokeMethod('isDeviceUseVPN');
    return version;
  }

  /// Retrieves data about the current proxy configuration on the device.
  /// Returns a [Map] containing proxy data like proxyHost, proxyPort, proxyType, or `null` if no proxy is configured.
  @override
  Future<Map?> dataOfCurrentProxy() async {
    final version = await methodChannel.invokeMethod('dataOfCurrentProxy');
    return version;
  }

  /// Checks if the developer mode is enabled on the device.
  /// Returns a [bool] indicating whether developer mode is on.
  @override
  Future<bool?> checkIsTheDeveloperModeOn() async {
    final version =
        await methodChannel.invokeMethod('checkIsTheDeveloperModeOn');
    return version;
  }

  /// Checks if the app in the testflight.
  /// Returns a [bool] indicating whether app in the testflight for ios.
  @override
  Future<bool?> isRunningInTestFlight() async {
    if (Platform.isIOS) {
      final version = await methodChannel.invokeMethod('isRunningInTestFlight');
      return version;
    } else {
      return false;
    }
  }

  /// Checks if the device is real.
  /// Returns a [bool] indicating whether developer mode is on.
  @override
  Future<bool?> isItRealDevice() async {
    final value = await methodChannel.invokeMethod('isItRealDevice');
    print('isItRealDevice:$value');
    return value;
  }

  /// Disables the ability to take screenshots on the device.
  /// This is useful for protecting sensitive information.
  @override
  Future<void> turnOffScreenshots() async {
    await methodChannel.invokeMethod('turnOffScreenshots');
  }

  /// Checks if the device is jailbroken (iOS) or rooted (Android).
  /// Returns a [bool] indicating whether the device is jailbroken or rooted.
  @override
  Future<bool?> isUseJailBrokenOrRoot() async {
    final version = await methodChannel.invokeMethod('isUseJailBrokenOrRoot');
    return version;
  }

  /// Stream to listen for screenshot or screen recording attempts.
  /// Only support ios
  @override
  Stream<String> get onScreenCaptureDetected {
    return eventChannel
        .receiveBroadcastStream()
        .map((event) => event.toString());
  }
}
