//
//  CredentialManager.swift
//  BeautyShop
//
//  Created by Ермоленко Константин on 29.11.2020.
//  Copyright © 2020 Ермоленко Константин. All rights reserved.
//

import Foundation

class CredentialManager {
  
  // MARK: - Public properties
  
  static let shared = CredentialManager()
  
  // MARK: - Initialization
  
  private init() {}

  // MARK: - Public methods
  
  func apiKeyInKeychainExists() -> Bool {
    if let _ = retrieveUserCredentials() {
      return true
    }
    return false
  }

  func userCredentialsInKeychainExists() -> Bool {
    if let _ = retrieveUserCredentials() {
      return true
    }
    return false
  }
  
  func saveUserCredentials(credentials: Credentials) {
    deleteOldCredentials()
    saveNewCredentials(credentials: credentials)
  }
  
  func retrieveUserCredentials() -> Credentials? {
    do {
      let credentials = try searchCredentials()
      return credentials
    } catch {
      return nil
    }
  }

  func saveApiKey(apiKey: String) {
    do {
      try deleteOldApiKey()
    } catch {
      print(error.localizedDescription)
    }
    do {
      try saveNewApiKey(apiKey: apiKey)
    } catch {
      print(error.localizedDescription)
    }
  }
  
  func retrieveApiKey() -> String? {
    do {
      let apiKey = try searchApiKey()
      return apiKey
    } catch {
      return nil
    }
  }
  
  // MARK: - Private methods

  private func deleteOldCredentials() {
    let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword]
    let _ = SecItemDelete(query as CFDictionary)
  }
  
  private func saveNewCredentials(credentials: Credentials) {
    let account = credentials.username
    let password = credentials.password.data(using: String.Encoding.utf8)!
    let addquery: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                kSecAttrAccount as String: account,
                                kSecValueData as String: password]

    let _ = SecItemAdd(addquery as CFDictionary, nil)
  }

  private func searchCredentials() throws -> Credentials? {
    let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                kSecMatchLimit as String: kSecMatchLimitOne,
                                kSecReturnAttributes as String: true,
                                kSecReturnData as String: true]
    var item: CFTypeRef?
    let status = SecItemCopyMatching(query as CFDictionary, &item)
    guard status != errSecItemNotFound else { throw KeychainError.noPassword }
    guard status == errSecSuccess else { throw KeychainError.unhandledError(status: status) }
    
    guard let existingItem = item as? [String : Any],
        let passwordData = existingItem[kSecValueData as String] as? Data,
        let password = String(data: passwordData, encoding: String.Encoding.utf8),
        let account = existingItem[kSecAttrAccount as String] as? String
    else {
        throw KeychainError.unexpectedPasswordData
    }
    let credentials = Credentials(username: account, password: password)
    
    return credentials
  }
  
  private func deleteOldApiKey() throws {
    let query: [String: Any] = [kSecClass as String: kSecClassKey]
    let status = SecItemDelete(query as CFDictionary)
    guard status == errSecSuccess || status == errSecItemNotFound else { throw KeychainError.unhandledError(status: status) }
  }

  private func saveNewApiKey(apiKey: String) throws {
    let key = apiKey.data(using: .utf8)!
    let tag = "com.example.keys.mykey".data(using: .utf8)!
    let addquery: [String: Any] = [kSecClass as String: kSecClassKey,
                                   kSecAttrApplicationTag as String: tag,
                                   kSecValueData as String: key]
    let status = SecItemAdd(addquery as CFDictionary, nil)
    guard status == errSecSuccess else { throw KeychainError.unhandledError(status: status) }
  }

  private func searchApiKey() throws -> String? {
    let tag = "com.example.keys.mykey".data(using: .utf8)!
    let getquery: [String: Any] = [kSecClass as String: kSecClassKey,
                                   kSecMatchLimit as String: kSecMatchLimitOne,
                                   kSecReturnAttributes as String: true,
                                   kSecReturnData as String: true,
                                   kSecAttrApplicationTag as String: tag]
    
    var item: CFTypeRef?
    let status = SecItemCopyMatching(getquery as CFDictionary, &item)
    guard status == errSecSuccess else { throw KeychainError.unexpectedApiKeyData }
    
    guard let existingItem = item as? [String : Any],
        let keyData = existingItem[kSecValueData as String] as? Data,
        let key = String(data: keyData, encoding: String.Encoding.utf8)
    else {
        throw KeychainError.unexpectedApiKeyData
    }

    return key
  }

  enum KeychainError: Error {
    case noPassword
    case unexpectedPasswordData
    case unexpectedApiKeyData
    case unhandledError(status: OSStatus)
  }
}

extension OSStatus {
    var error: NSError? {
        guard self != errSecSuccess else { return nil }

        let message = SecCopyErrorMessageString(self, nil) as String? ?? "Unknown error"

        return NSError(domain: NSOSStatusErrorDomain, code: Int(self), userInfo: [
            NSLocalizedDescriptionKey: message])
    }
}
