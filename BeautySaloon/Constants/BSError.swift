//
//  BSError.swift
//  BeautyShop
//
//  Created by Ермоленко Константин on 20.10.2020.
//  Copyright © 2020 Ермоленко Константин. All rights reserved.
//

import Foundation

enum BSError: String, Error {
  case unknown = "Unknown error"
  case invalidURL = "URL is invalid"
  case invalidData = "The data received from the server was invalid. Please try again."
  case invalidResponse = "Invalid response from the server. Please try again."
  case unableToComplete = "Unable to complete your request. Please check your internet connection."
  case invalidUsernameOrPassword = "Неверные логин или пароль."
  case credentialsNotFound
  case unuthorized
  case forbidden
}

