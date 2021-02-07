//
//  DataSource.swift
//  BeautyShop
//
//  Created by Ермоленко Константин on 20.10.2020.
//  Copyright © 2020 Ермоленко Константин. All rights reserved.
//

import Foundation

class DataSource {
  
  // MARK: - Public properties
  
  static let shared = DataSource()
  
  // MARK: - Private properties
  
  private var schedule = Schedule()
  private var subordinates = [Subordinate]()
  
  private init() {}
  
  // MARK: - Public methods
  
  func fetchSchedule() {
    guard let userInfo = PersistenceManager.retrieveUserInfo() else {
      notifyScheduleFetched(withResult: DataFetchingResults.authUnauthorized)
      return
    }
    
    fetchSchedule(userId: userInfo.id)
  }

  func fetchSchedule(forUserId: String) {
    fetchSchedule(userId: forUserId)
  }
  
  private func fetchSchedule(userId: String) {
    guard let apiKey = CredentialManager.shared.retrieveApiKey() else {
      addObserversApiKeyUpdated()
      notifyScheduleFetched(withResult: DataFetchingResults.authUnauthorized)
      return
    }
    
    NetworkManager.shared.fetchSchedule(apiKey: apiKey, userId: userId) { result in
      switch result {
      case .success(let schedule):
        self.saveSchedule(schedule)
        self.notifyScheduleFetched(withResult: DataFetchingResults.completedSuccessfully)
        
      case .failure(let error):
        if error == .unuthorized {
          self.notifyScheduleFetched(withResult: DataFetchingResults.authUnauthorized)

        } else if error == .forbidden {
          self.addObserversApiKeyUpdated()
          self.notifyScheduleFetched(withResult: DataFetchingResults.authForbidden)
        }
         
        else {
          self.notifyScheduleFetched(withResult: DataFetchingResults.completedWithError)
        }
      }
    }
  }
  
  func updateApiKey() {
    guard let credentials = CredentialManager.shared.retrieveUserCredentials() else {
      self.addObserversApiKeyUpdated()
      self.notifyScheduleFetched(withResult: DataFetchingResults.authForbidden)
      return
    }
    
    NetworkManager.shared.passAuthentication(credentials: credentials) { result in
      switch result {
      case .success(let authData):
        CredentialManager.shared.saveApiKey(apiKey: authData.apiKey)

        self.notifyScheduleFetched(withResult: DataFetchingResults.apiKeyUpdated)

        return
        
      case .failure(let error):
        if error == .unuthorized {
          self.notifyScheduleFetched(withResult: DataFetchingResults.authUnauthorized)
        } else if error == .forbidden {
          self.notifyScheduleFetched(withResult: DataFetchingResults.authForbidden)
        }

        return
      }
    }
  }

  func getUserInfo() -> UserInfo {
    if let userInfo = PersistenceManager.retrieveUserInfo() {
      return userInfo
    } else {
      return UserInfo(id: "", role: "master", username: "unknown")
    }
  }
  
  func getSubordinates() {
    guard let apiKey = CredentialManager.shared.retrieveApiKey() else {
      addObserversApiKeyUpdated()
      notifyScheduleFetched(withResult: DataFetchingResults.authUnauthorized)
      return
    }
    guard let userInfo = PersistenceManager.retrieveUserInfo() else {
      notifyScheduleFetched(withResult: DataFetchingResults.authUnauthorized)
      return
    }
    guard userInfo.role == .administrator else { return }

    NetworkManager.shared.fetchSubordinates(apiKey: apiKey, userId: userInfo.id) { result in
      switch result {
      case .success(let subordinates):
        self.saveSubordinates(subordinates)
      case .failure(let error):
        if error == .unuthorized {
          self.notifyScheduleFetched(withResult: DataFetchingResults.authUnauthorized)

        } else if error == .forbidden {
          self.addObserversApiKeyUpdated()
          self.notifyScheduleFetched(withResult: DataFetchingResults.authForbidden)
        }
         
        else {
          print(error)
        }
      }
    }
      
  }
  
  func saveSchedule(_ schedule: Schedule) {
    self.schedule = schedule
    
    PersistenceManager.saveSchedule(schedule: schedule)
  }
  
  func saveSubordinates(_ subordinates: [Subordinate]) {
    self.subordinates = subordinates
    
    PersistenceManager.saveSubordinates(subordinates: subordinates)
  }
  
  func initAppData() {
    
    let result = PersistenceManager.retrieveEvents()
    switch result {
    case .success(let events):
      schedule = events
    case .failure(let error):
      print("Error while getting events fo date: \(error.rawValue)")
    }
  }
    
  func getEvents(at date: Date) -> [Event] {
    if let eventsForDate = schedule[date.convertToYearMounthDay()] {
      return eventsForDate
    } else {
      return [Event]()
    }
  }
  
  func getSummaryInfo(at date: Date) -> DayInfo {
    if let eventsForDate = schedule[date.convertToYearMounthDay()] {
      return DayInfo(date: date, numberOfClients: eventsForDate.count)
    } else {
      return DayInfo(date: date, numberOfClients: 0)
    }
  }
  
  func getEvent(by id: String, at date: Date) -> Event? {
    if let eventsForDate = schedule[date.convertToYearMounthDay()] {
      return eventsForDate.first { $0.id == id }
    } else {
      return nil
    }
  }

  // MARK: - Private methods

  private func addObserversApiKeyUpdated() {
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(handleApiKeyUpdated(notification:)),
      name: DataFetchingResults.apiKeyUpdated,
      object: nil
    )
  }
  
  @objc private func handleApiKeyUpdated(notification: Notification) {
    guard notification.name == DataFetchingResults.apiKeyUpdated else { return }

    fetchSchedule()
  }
    
  // MARK: - Notifications

  private func notifyScheduleFetched(withResult result: NSNotification.Name) {
    NotificationCenter.default.post(name: result, object: nil)
  }
}
