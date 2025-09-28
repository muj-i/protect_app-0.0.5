

public class ProxyManager {
    static func getProxyData() -> [String: String?] {
         guard let proxySettings = CFNetworkCopySystemProxySettings()?.takeRetainedValue() as? [String: Any],
                      let proxies = proxySettings["__SCOPED__"] as? [String: Any] else {
                    return [:]
                }

                var proxyData: [String: String?] = [:]
                for (_, value) in proxies {
                    if let proxy = value as? [String: Any] {
                        proxyData["proxyHost"] = proxy[kCFProxyHostNameKey as String] as? String
                        proxyData["proxyPort"] = proxy[kCFProxyPortNumberKey as String] as? String
                        proxyData["proxyType"] = proxy[kCFProxyTypeKey as String] as? String
                    }
                }
                return proxyData
    }
}
