import Foundation
import UIKit

public class DeveloperModeManager {
    static func isDeveloperModeEnabled() -> Bool {
        if let url = URL(string: "apple-magnifier://"), UIApplication.shared.canOpenURL(url) {
            return true
        }
        return false
    }
    static func isItRealDevice() -> Bool {
        #if targetEnvironment(simulator)
            return false
        #else
            return true
        #endif
    }

    static func isJailbroken() -> Bool {
        let paths = [
            "/Applications/Cydia.app",
            "/Library/MobileSubstrate/MobileSubstrate.dylib",
            "/bin/bash",
            "/usr/sbin/sshd",
            "/etc/apt"
        ]

        for path in paths {
            if FileManager.default.fileExists(atPath: path) {
                return true
            }
        }

        if let url = URL(string: "cydia://package/com.saurik.Cydia"), UIApplication.shared.canOpenURL(url) {
            return true
        }

        return false
    }
    static func isRunningInTestFlight() -> Bool {
        if let bundleIdentifier = Bundle.main.bundleIdentifier, bundleIdentifier.hasSuffix(".beta") {
            return true
        }
        if let appStoreReceiptURL = Bundle.main.appStoreReceiptURL, appStoreReceiptURL.lastPathComponent == "sandboxReceipt" {
            return true
        }
        return false
    }
}
