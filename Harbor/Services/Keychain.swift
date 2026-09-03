import Foundation
import Security

enum Keychain {
    static let service = "ai.harbor.app"
    static let account = "apiKey"

    static var apiKey: String? {
        get {
            let query: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrService as String: service,
                kSecAttrAccount as String: account,
                kSecReturnData as String: true,
                kSecMatchLimit as String: kSecMatchLimitOne
            ]
            var result: AnyObject?
            let status = SecItemCopyMatching(query as CFDictionary, &result)
            guard status == errSecSuccess, let data = result as? Data else { return nil }
            return String(data: data, encoding: .utf8)
        }
        set {
            let query: [String: Any] = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrService as String: service,
                kSecAttrAccount as String: account
            ]
            guard let newValue, let data = newValue.data(using: .utf8), !newValue.isEmpty else {
                SecItemDelete(query as CFDictionary)
                return
            }
            let attributes: [String: Any] = [
                kSecValueData as String: data,
                kSecAttrAccessible as String: kSecAttrAccessibleWhenUnlockedThisDeviceOnly
            ]
            SecItemDelete(query as CFDictionary)
            SecItemAdd(query.merging(attributes) { $1 } as CFDictionary, nil)
        }
    }
}
