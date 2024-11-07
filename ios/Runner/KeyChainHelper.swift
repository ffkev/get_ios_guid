//
//  KeyChainHelper.swift
//  Runner
//
//  Created by Kevinton on 05/11/24.
//

import Foundation
import Security

class IPKeyChainItemWrapper {
    // Method to retrieve an item from Keychain for a specific key
    static func keyChainItem(forKey key: String) -> AnyObject? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true
        ]
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        if status == errSecSuccess, let data = dataTypeRef as? Data {
            return String(data: data, encoding: .utf8) as AnyObject
        }
        return nil
    }
    
    // Method to store an item in Keychain for a specific key
    static func setKeyChainItem(_ value: String?, forKey key: String) {
        let data = value?.data(using: .utf8)
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        
        // First delete any existing item with the same key
        SecItemDelete(query as CFDictionary)
        
        // Then add the new item to the Keychain
        if let data = data {
            var addQuery = query
            addQuery[kSecValueData as String] = data
            SecItemAdd(addQuery as CFDictionary, nil)
        }
    }
}
