import Foundation
import Flutter
import UIKit
import Foundation
import Network

public class ProtectAppPlugin: NSObject, FlutterPlugin {
    private static var screenCaptureDetector: ScreenCaptureDetector?
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "protect_app", binaryMessenger: registrar.messenger())
        let instance = ProtectAppPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
        
        // Register event channel for screen capture detection
        let eventChannel = FlutterEventChannel(name: "protect_app/screen_capture", binaryMessenger: registrar.messenger())
        screenCaptureDetector = ScreenCaptureDetector()
        eventChannel.setStreamHandler(screenCaptureDetector)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "isDeviceUseVPN":
            result(VPNManager.isVpnActive())
        case "dataOfCurrentProxy":
            result(ProxyManager.getProxyData())
        case "checkIsTheDeveloperModeOn":
            result(DeveloperModeManager.isDeveloperModeEnabled())
        case "isItRealDevice":
            result(DeveloperModeManager.isItRealDevice())
        case "isUseJailBrokenOrRoot":
            result(DeveloperModeManager.isJailbroken())
        case "isRunningInTestFlight":
            result(DeveloperModeManager.isRunningInTestFlight())
        case "turnOffScreenshots":
            if let window = UIApplication.shared.windows.first {
                TurnOffScreenshots.turnOff(on: window)
                result(nil)
            } else {
                result(FlutterError(code: "UNAVAILABLE", message: "Window is not available", details: nil))
            }
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}