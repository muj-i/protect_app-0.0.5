// import 'package:flutter_test/flutter_test.dart';
// import 'package:protect_app/protect_app.dart';
// import 'package:protect_app/protect_app_platform_interface.dart';
// import 'package:protect_app/protect_app_method_channel.dart';
// import 'package:plugin_platform_interface/plugin_platform_interface.dart';
//
// class MockProtectAppPlatform
//     with MockPlatformInterfaceMixin
//     implements ProtectAppPlatform {
//
//   @override
//   Future<String?> getPlatformVersion() => Future.value('42');
// }
//
// void main() {
//   final ProtectAppPlatform initialPlatform = ProtectAppPlatform.instance;
//
//   test('$MethodChannelProtectApp is the default instance', () {
//     expect(initialPlatform, isInstanceOf<MethodChannelProtectApp>());
//   });
//
//   test('getPlatformVersion', () async {
//     ProtectApp protectAppPlugin = ProtectApp();
//     MockProtectAppPlatform fakePlatform = MockProtectAppPlatform();
//     ProtectAppPlatform.instance = fakePlatform;
//
//     // expect(await protectAppPlugin.getPlatformVersion(), '42');
//   });
// }
