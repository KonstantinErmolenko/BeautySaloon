//
//  SplashScreenVC.swift
//  BeautyShop
//
//  Created by Ермоленко Константин on 18.11.2020.
//  Copyright © 2020 Ермоленко Константин. All rights reserved.
//

import UIKit

typealias authResult = Result<String, BSError>

class SplashScreenVC: UIViewController {
  
  // MARK: - Properties
  
  let imageLogo = UIImageView()
  
  // MARK: - Lifecycle methods
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configure()
    initializeAppData()
  }
  
  // MARK: - Configuring methods
  
  func configure(){
    view.backgroundColor = Colors.mainColor
    view.addSubview(imageLogo)
    imageLogo.image = UIImage(named: "logo")
    imageLogo.contentMode = .scaleAspectFit
    
    imageLogo.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      imageLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      imageLogo.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      imageLogo.widthAnchor.constraint(equalToConstant: 266),
      imageLogo.heightAnchor.constraint(equalToConstant: 217)
    ])
  }
  
  // MARK: - Private methods
  
  private func initializeAppData() {
    if CredentialManager.shared.apiKeyInKeychainExists() {
      DataSource.shared.fetchSchedule()
      DataSource.shared.getSubordinates()
    } else {
      notifyScheduleFetched(withResult: DataFetchingResults.authUnauthorized)
    }
  }
  
  // MARK: - Notifications
  
  private func addObserversApiKeyUpdated() {
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(handleApiKeyUpdated),
      name: DataFetchingResults.apiKeyUpdated,
      object: nil
    )
  }
  
  @objc private func handleApiKeyUpdated() {
    DataSource.shared.fetchSchedule()
  }

  private func notifyScheduleFetched(withResult result: NSNotification.Name) {
    NotificationCenter.default.post(name: result, object: nil)
  }
}
