//
//  DataFetchingResults.swift
//  BeautyShop
//
//  Created by Ермоленко Константин on 04.12.2020.
//  Copyright © 2020 Ермоленко Константин. All rights reserved.
//

import Foundation

enum DataFetchingResults {
  
  // MARK: - Public properties
  
  static let completedSuccessfully = NSNotification.Name(
      rawValue: "completedSuccessfully"
  )
  static let completedWithError = NSNotification.Name(
      rawValue: "completedWithError"
  )
  static let authenticationSucceeded = NSNotification.Name(
      rawValue: "authenticationSucceeded"
  )
  static let authForbidden = NSNotification.Name(
      rawValue: "authForbidden"
  )
  static let authUnauthorized = NSNotification.Name(
      rawValue: "authUnuthorized"
  )
  static let apiKeyUpdated = NSNotification.Name(
      rawValue: "apiKeyUpdated"
  )
}
