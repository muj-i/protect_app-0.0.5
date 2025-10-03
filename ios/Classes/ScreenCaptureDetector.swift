import Foundation
import UIKit
import Flutter

/// Manages detection of screenshot and screen recording events on iOS
class ScreenCaptureDetector: NSObject, FlutterStreamHandler {
    private var eventSink: FlutterEventSink?
    private var isMonitoring = false
    
    /// Called when a Flutter app starts listening to the event stream
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = events
        startMonitoring()
        return nil
    }
    
    /// Called when a Flutter app stops listening to the event stream
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        stopMonitoring()
        self.eventSink = nil
        return nil
    }
    
    /// Start monitoring for screenshot and screen recording events
    private func startMonitoring() {
        guard !isMonitoring else { return }
        isMonitoring = true
        
        // Listen for screenshot notifications
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(screenshotTaken),
            name: UIApplication.userDidTakeScreenshotNotification,
            object: nil
        )
        
        // Listen for screen recording status changes (iOS 11+)
        if #available(iOS 11.0, *) {
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(screenRecordingChanged),
                name: UIScreen.capturedDidChangeNotification,
                object: nil
            )
        }
    }
    
    /// Stop monitoring for screenshot and screen recording events
    private func stopMonitoring() {
        guard isMonitoring else { return }
        isMonitoring = false
        
        NotificationCenter.default.removeObserver(
            self,
            name: UIApplication.userDidTakeScreenshotNotification,
            object: nil
        )
        
        if #available(iOS 11.0, *) {
            NotificationCenter.default.removeObserver(
                self,
                name: UIScreen.capturedDidChangeNotification,
                object: nil
            )
        }
    }
    
    /// Called when a screenshot is taken
    @objc private func screenshotTaken() {
        eventSink?("screenshot")
    }
    
    /// Called when screen recording status changes
    @objc private func screenRecordingChanged() {
        if #available(iOS 11.0, *) {
            if UIScreen.main.isCaptured {
                eventSink?("screen_recording")
            }
        }
    }
    
    deinit {
        stopMonitoring()
    }
}
