//
//  PersistenceManager.swift
//  BeautyShop
//
//  Created by Ермоленко Константин on 20.10.2020.
//  Copyright © 2020 Ермоленко Константин. All rights reserved.
//

import Foundation

enum PersistenceManager {
  
  // MARK: - Public properties
  
  static private let defaults = UserDefaults.standard
    
  static func saveSchedule(schedule: Schedule) {
    do {
      let encoder = JSONEncoder()
      let encodedData = try encoder.encode(schedule)
      defaults.set(encodedData, forKey: UserDefaults.Keys.schedule)
    } catch {}
  }
  
  static func saveSubordinates(subordinates: [Subordinate]) {
    do {
      let encoder = JSONEncoder()
      let encodedData = try encoder.encode(subordinates)
      defaults.set(encodedData, forKey: UserDefaults.Keys.subordinates)
    } catch {}
  }
  
  static func saveUserInfo(userInfo: UserInfo) {
    do {
      let encoder = JSONEncoder()
      let encodedData = try encoder.encode(userInfo)
      defaults.set(encodedData, forKey: UserDefaults.Keys.userInfo)
    } catch {}
  }
  
  static func retrieveUserInfo() -> UserInfo? {
    guard let encodedData = defaults.object(forKey: UserDefaults.Keys.userInfo) as? Data else {
      return nil
    }
    
    do {
      let decoder = JSONDecoder()
      let userInfo = try decoder.decode(UserInfo.self, from: encodedData)
      return userInfo
    } catch {
      return nil
    }
  }
  
  static func retrieveSubordinates() -> [Subordinate]? {
    guard let encodedData = defaults.object(forKey: UserDefaults.Keys.subordinates) as? Data else {
      return nil
    }
    
    do {
      let decoder = JSONDecoder()
      let subordinates = try decoder.decode([Subordinate].self, from: encodedData)
      return subordinates
    } catch {
      return nil
    }
  }
  
  static func retrieveEvents() -> Result<Schedule, BSError> {
    guard let eventsData = defaults.object(forKey: UserDefaults.Keys.schedule) as? Data else {
      return .success(Schedule())
    }
    
    do {
      let decoder = JSONDecoder()
      let events = try decoder.decode(Schedule.self, from: eventsData)
      return .success(events)
    } catch {
      return .failure(.unknown)
    }
  }
}
