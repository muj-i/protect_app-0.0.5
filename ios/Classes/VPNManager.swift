import Foundation
import Network

public class VPNManager {
    static func isVpnActive() -> Bool {
        let monitor = NWPathMonitor()
                let semaphore = DispatchSemaphore(value: 0)
                var isVpnEnabled = false

                monitor.pathUpdateHandler = { path in
                    if path.usesInterfaceType(.other) {
                        isVpnEnabled = true
                    }
                    semaphore.signal()
                }

                let queue = DispatchQueue(label: "VPNCheck")
                monitor.start(queue: queue)

                _ = semaphore.wait(timeout: .now() + 2)
                monitor.cancel()
                return isVpnEnabled
    }
}
