//
//  UserInfo.swift
//  BeautyShop
//
//  Created by Ермоленко Константин on 27.01.2021.
//  Copyright © 2021 Ермоленко Константин. All rights reserved.
//

import Foundation

struct UserInfo: Codable {
  let id: String
  let role: UserRoles
  let username: String
  
  init(id: String, role: String, username: String) {
    self.id = id
    if role == "Администратор" {
      self.role = .administrator
    } else {
      self.role = .master
    }
    self.username = username
  }
}

enum UserRoles: String, Codable {
  case master = "master"
  case administrator = "administrator"
}
