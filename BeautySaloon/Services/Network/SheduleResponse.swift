//
//  SheduleResponse.swift
//  BeautyShop
//
//  Created by Ермоленко Константин on 23.11.2020.
//  Copyright © 2020 Ермоленко Константин. All rights reserved.
//

import Foundation

struct ScheduleServerResponse: Decodable {
  let error: Bool
  let message: String
  let data: ScheduleResponseData
}

struct SubordinatesServerResponse: Decodable {
  let error: Bool
  let message: String
  let data: [Subordinate]
}

struct ScheduleResponseData: Decodable {
  let schedule: Schedule
  let workingHours: WorkingHours
}

struct Subordinate: Codable {
  let id: String
  let name: String
}

struct WorkingHours: Decodable {
  let start: String
  let end: String
}

struct AuthResponse: Decodable {
  let error: Bool
  let message: String
  let data: AuthData
}

struct AuthData: Decodable {
  let id: String
  let role: String
  let username: String
  let apiKey: String
}
