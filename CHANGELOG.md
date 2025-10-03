# Change log

All notable changes to this project will be documented in this file.

## [0.0.6] - 2025-10-04

### Added

- 🎉 **NEW FEATURE**: Real-time screenshot and screen recording detection
  - Added `onScreenCaptureDetected` stream to listen for screen capture attempts
  - iOS: Detects both screenshots and screen recording (iOS 11+)
  - Android: Detects screenshots via MediaStore monitoring
  - Implemented using EventChannel for efficient real-time streaming
  - Created comprehensive documentation (SCREEN_CAPTURE_DETECTION.md)
  - Created integration guide for parent apps (INTEGRATION_GUIDE.md)
  - Updated example app with working implementation

### Modified

- Updated README.md with new feature documentation
- Added required permissions for Android (READ_EXTERNAL_STORAGE, READ_MEDIA_IMAGES)
- Enhanced example app to demonstrate screen capture detection

### Technical Changes

- Created ScreenCaptureDetector.swift for iOS implementation
- Created ScreenCaptureDetector.kt for Android implementation
- Updated ProtectAppPlugin (both iOS and Android) to support EventChannel
- Added event streaming support to protect_app_method_channel.dart
- Added stream interface to protect_app_platform_interface.dart

## [0.0.1] - 2025-02-02

### Added

- Initial release of the plugin.
- Added functionality to detect if the device is using a VPN.
- Added functionality to get data of the current proxy.
- Added functionality to detect if developer mode is enabled.
- Added functionality to detect if the device is jailbroken or rooted.
- Added functionality to disable screenshots.

## [0.0.2] - 2025-02-07

### Added

- Added functionality to detect if the device is real or an emulator.
- update the README.md file.

## [0.0.3] - 2025-02-09

### Added

- fixed bug of detect the real devices
