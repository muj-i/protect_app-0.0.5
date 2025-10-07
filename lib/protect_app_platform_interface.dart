import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'protect_app_method_channel.dart';

/// Abstract class defining the interface for the ProtectApp platform.
/// This class serves as a bridge between the platform-specific implementation and the Flutter app.
abstract class ProtectAppPlatform extends PlatformInterface {
  /// Constructor for the [ProtectAppPlatform].
  ProtectAppPlatform() : super(token: _token);

  /// Token used for platform interface verification.
  static final Object _token = Object();

  /// Singleton instance of [ProtectAppPlatform].
  static ProtectAppPlatform _instance = MethodChannelProtectApp();

  /// Getter for the singleton instance.
  static ProtectAppPlatform get instance => _instance;

  /// Setter for the singleton instance.
  /// This allows for overriding the default implementation with a custom one.
  static set instance(ProtectAppPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Method to check if the device is using a VPN.
  /// Throws [UnimplementedError] if not overridden by a platform-specific implementation.
  Future<bool?> isDeviceUseVPN() {
    throw UnimplementedError('Failed to check if device use VPN.');
  }

  /// Method to retrieve data about the current proxy configuration.
  /// Throws [UnimplementedError] if not overridden by a platform-specific implementation.
  Future<Map?> dataOfCurrentProxy() {
    throw UnimplementedError('Failed to get data of proxy.');
  }

  /// Method to check if the device is real.
  /// Throws [UnimplementedError] if not overridden by a platform-specific implementation.
  Future<bool?> isItRealDevice() {
    throw UnimplementedError('Failed to check if device is real.');
  }

  /// Method to check if the app in the testflight.
  /// Throws [UnimplementedError] if not overridden by a platform-specific implementation.
  Future<bool?> isRunningInTestFlight() {
    throw UnimplementedError('Failed to check if app on testflight.');
  }

  /// Method to check if the developer mode is enabled on the device.
  /// Throws [UnimplementedError] if not overridden by a platform-specific implementation.
  Future<bool?> checkIsTheDeveloperModeOn() {
    throw UnimplementedError('Failed to check if device is in developer mode.');
  }

  /// Method to disable screenshots on the device.
  /// Throws [UnimplementedError] if not overridden by a platform-specific implementation.
  Future<void> turnOffScreenshots() {
    throw UnimplementedError('Failed to turn off screenshots.');
  }

  /// Method to check if the device is jailbroken or rooted.
  /// Throws [UnimplementedError] if not overridden by a platform-specific implementation.
  Future<bool?> isUseJailBrokenOrRoot() {
    throw UnimplementedError(
        'Failed to detect if device is jailbroken or rooted.');
  }

  /// Stream to listen for screenshot or screen recording attempts.
  /// Returns a [Stream<String>] that emits events when a screenshot or screen recording is detected.
  /// Event values: 'screenshot' or 'screen_recording'
  /// Only support ios
  Stream<String> get onScreenCaptureDetected {
    throw UnimplementedError('Failed to listen for screen capture events.');
  }
}
