import 'protect_app_platform_interface.dart';

/// Main class for interacting with the ProtectApp functionality.
/// This class provides methods to check device security settings and configurations.
class ProtectApp {
  /// Checks if the device is currently using a VPN.
  /// Returns a [bool] indicating whether the device is using a VPN.
  Future<bool?> isDeviceUseVPN() {
    return ProtectAppPlatform.instance.isDeviceUseVPN();
  }

  /// Retrieves data about the current proxy configuration on the device.
  /// Returns a [Map] containing proxy data, or `null` if no proxy is configured.
  Future<Map?> dataOfCurrentProxy() {
    return ProtectAppPlatform.instance.dataOfCurrentProxy();
  }

  /// Checks if the developer mode is enabled on the device.
  /// Returns a [bool] indicating whether developer mode is on.
  Future<bool?> checkIsTheDeveloperModeOn() {
    return ProtectAppPlatform.instance.checkIsTheDeveloperModeOn();
  }

  /// Disables the ability to take screenshots on the device.
  /// This is useful for protecting sensitive information.
  Future<void> turnOffScreenshots() {
    return ProtectAppPlatform.instance.turnOffScreenshots();
  }

  /// Checks if the device is jailbroken (iOS) or rooted (Android).
  /// Returns a [bool] indicating whether the device is jailbroken or rooted.
  Future<bool?> isUseJailBrokenOrRoot() {
    return ProtectAppPlatform.instance.isUseJailBrokenOrRoot();
  }

  /// Checks if the device is real.
  /// Returns a [bool] indicating whether device is real.
  Future<bool?> isItRealDevice() {
    return ProtectAppPlatform.instance.isItRealDevice();
  }

  /// Checks if the app in testflight.
  /// Returns a [bool] indicating whether app in testflight.
  Future<bool?> isRunningInTestFlight() {
    return ProtectAppPlatform.instance.isRunningInTestFlight();
  }

  /// Listens for screenshot or screen recording attempts.
  /// Returns a [Stream<String>] that emits events when screen capture is detected.
  /// Event values: 'screenshot' or 'screen_recording'
  ///
  /// Example usage:
  /// ```dart
  /// ProtectApp().onScreenCaptureDetected.listen((event) {
  ///   if (event == 'screenshot') {
  ///     // Show error message for screenshot
  ///   } else if (event == 'screen_recording') {
  ///     // Show error message for screen recording
  ///   }
  /// });
  /// ```
  Stream<String> get onScreenCaptureDetected {
    return ProtectAppPlatform.instance.onScreenCaptureDetected;
  }
}
