//
//  NetworkManager.swift
//  BeautyShop
//
//  Created by Ермоленко Константин on 09.11.2020.
//  Copyright © 2020 Ермоленко Константин. All rights reserved.
//

import UIKit

class NetworkManager {
  
  // MARK: - Public properties
  
  static let shared = NetworkManager()
  
  // MARK: - Private properties
  
  private let baseUrl = "http://192.168.1.18/BeautyShop/hs/beauty_master"
  
  private let cache = NSCache<NSString, UIImage>()
  
  // MARK: - Initialization
  
  private init() {}
  
  // MARK: - Public methods
  
  func fetchSchedule(apiKey: String, userId: String, completed: @escaping (Result<Schedule, BSError>) ->  Void) {
    
    var scheduleURLComponents = URLComponents(string: baseUrl + "/schedule")!
    scheduleURLComponents.queryItems = fetchScheduleParameters(userId: userId)
    guard let url = scheduleURLComponents.url else {
      completed(.failure(.invalidURL))
      return
    }
    
    let session = configuredURLSession(headers: ["apiKey": apiKey])
    
    let task = session.dataTask(with: url) { data, response, error in
      if let _ = error {
        completed(.failure(.unableToComplete))
        return
      }
      
      guard let response = response as? HTTPURLResponse else {
        completed(.failure(.invalidResponse))
        return
      }
      
      if response.statusCode == 401  {
        completed(.failure(.unuthorized))
        return
      } else if response.statusCode == 403  {
        completed(.failure(.forbidden))
        return
      } else if response.statusCode != 200 {
        completed(.failure(.invalidResponse))
      }
      
      guard let data = data else {
        completed(.failure(.invalidData))
        return
      }

      do {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let response = try decoder.decode(ScheduleServerResponse.self, from: data)
        completed(.success(response.data.schedule))
      } catch {
        print(error.localizedDescription)
        completed(.failure(.invalidData))
      }
    }
    task.resume()
  }

  func passAuthentication(credentials: Credentials, completed: @escaping (Result<AuthData, BSError>) -> Void) {
    guard let url = URL(string: baseUrl + "/auth") else {
      completed(.failure(.invalidURL))
      return
    }
    guard let request = authenticationRequest(url: url, credentials: credentials) else {
      completed(.failure(.invalidData))
      return
    }
    
    let session = configuredURLSession()
    
    let task = session.dataTask(with: request as URLRequest) { data, response, error in
      guard error == nil else {
        completed(.failure(.unableToComplete))
        return
      }
      
      guard let response = response as? HTTPURLResponse else {
        completed(.failure(.invalidResponse))
        return
      }
      
      if response.statusCode == 401  {
        completed(.failure(.unuthorized))
        return
      } else if response.statusCode == 403  {
        completed(.failure(.forbidden))
        return
      } else if response.statusCode != 200 {
        completed(.failure(.invalidResponse))
      }
      
      guard let data = data else {
        completed(.failure(.invalidData))
        return
      }
      
      do {
        let decoder = JSONDecoder()
        let responseBody = try decoder.decode(AuthResponse.self, from: data)
        self.saveApiKey(apiKey: responseBody.data.apiKey)
        self.notifyScheduleFetched(withResult: DataFetchingResults.authenticationSucceeded)

        completed(.success(responseBody.data))
        
        return
      } catch {
        completed(.failure(.invalidData))
        return
      }
    }
    
    task.resume()
  }

  func fetchSubordinates(apiKey: String, userId: String, completed: @escaping (Result<[Subordinate], BSError>) ->  Void) {
    var scheduleURLComponents = URLComponents(string: baseUrl + "/subordinates")!
    scheduleURLComponents.queryItems = fetchScheduleParameters(userId: userId)
    guard let url = scheduleURLComponents.url else {
      completed(.failure(.invalidURL))
      return
    }
    
    let session = configuredURLSession(headers: ["apiKey": apiKey])
    
    let task = session.dataTask(with: url) { data, response, error in
      if let _ = error {
        completed(.failure(.unableToComplete))
        return
      }
      
      guard let response = response as? HTTPURLResponse else {
        completed(.failure(.invalidResponse))
        return
      }
      
      if response.statusCode == 401  {
        completed(.failure(.unuthorized))
        return
      } else if response.statusCode == 403  {
        completed(.failure(.forbidden))
        return
      } else if response.statusCode != 200 {
        completed(.failure(.invalidResponse))
      }
      
      guard let data = data else {
        completed(.failure(.invalidData))
        return
      }

      do {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let response = try decoder.decode(SubordinatesServerResponse.self, from: data)
        completed(.success(response.data))
      } catch {
        print(error.localizedDescription)
        completed(.failure(.invalidData))
      }
    }
    task.resume()
  }
  
  // MARK: - Private methods
  
  private func fetchScheduleParameters(userId: String) -> [URLQueryItem] {
    let formatter = ISO8601DateFormatter()
    formatter.timeZone = .autoupdatingCurrent
    
    let calendar = Calendar.autoupdatingCurrent
    let startDate = Date()
    let endDate = calendar.date(byAdding: .day, value: 6, to: startDate)!
    
    let queryItem1 = URLQueryItem(name: "startDate",
                                  value: startDate.getISOTimestamp(.withFullDate))
    let queryItem2 = URLQueryItem(name: "endDate",
                                  value: endDate.getISOTimestamp(.withFullDate))
    let queryItem3 = URLQueryItem(name: "userId",
                                  value: userId)
    
    return [queryItem1, queryItem2, queryItem3]
  }
  
  private func configuredURLSession(headers: [String: Any]? = nil) -> URLSession {
    let sessionConfig = URLSessionConfiguration.default
    sessionConfig.timeoutIntervalForRequest = 10
    sessionConfig.timeoutIntervalForResource = 15
    if let headers = headers {
      sessionConfig.httpAdditionalHeaders = headers
    }
    let session = URLSession(configuration: sessionConfig)
    
    return session
  }
  
  private func authenticationRequest(url: URL, credentials: Credentials) -> URLRequest? {
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    
    let base64EncodedCredentials = encodeCredentials(credentials: credentials)
    let parameters = ["auth": "\(base64EncodedCredentials)"]
    do {
      request.httpBody = try JSONSerialization.data(
        withJSONObject: parameters,
        options: .prettyPrinted
      )
    } catch {
      return nil
    }
    
    return request
  }

  private func encodeCredentials(credentials: Credentials) -> String {
    let authString = "\(credentials.username):\(credentials.password)"
    let base64Data = authString.data(using: .utf8)!.base64EncodedString()
    
    return base64Data
  }

  private func saveApiKey(apiKey key: String) {
    CredentialManager.shared.saveApiKey(apiKey: key)
  }
  
  private func notifyScheduleFetched(withResult result: NSNotification.Name) {
    NotificationCenter.default.post(name: result, object: nil)
  }
}
