//
//  SceneDelegate.swift
//  BeautyShop
//
//  Created by Ермоленко Константин on 13.07.2020.
//  Copyright © 2020 Ермоленко Константин. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {  
  var window: UIWindow?
  
  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let windowScene = (scene as? UIWindowScene) else { return }
    
    addObservers()
    createUIWindow(in: windowScene)
    configureNavigationBar()
  }
  
  private func configureNavigationBar() {
    UINavigationBar.appearance().tintColor = Colors.accentColor
  }
  
  private func createUIWindow(in windowScene: UIWindowScene) {
    window = UIWindow(frame: windowScene.coordinateSpace.bounds)
    window?.windowScene = windowScene
    
    window?.rootViewController = SplashScreenVC()
    window?.makeKeyAndVisible()
  }
  
  private func addObservers() {
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(loadingDataCompleted(notification:)),
      name: DataFetchingResults.completedSuccessfully,
      object: nil
    )
    
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(loadingDataCompleted(notification:)),
      name: DataFetchingResults.completedWithError,
      object: nil
    )
    
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(loadingDataCompleted(notification:)),
      name: DataFetchingResults.authUnauthorized,
      object: nil
    )
    
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(loadingDataCompleted(notification:)),
      name: DataFetchingResults.authForbidden,
      object: nil
    )
  }

  private func removeObservers() {
      NotificationCenter.default.removeObserver(
        self,
        name: DataFetchingResults.completedSuccessfully,
        object: nil
      )
  
      NotificationCenter.default.removeObserver(
        self,
        name: DataFetchingResults.completedWithError,
        object: nil
      )
    }
  
  @objc private func loadingDataCompleted(notification: Notification) {
    
    let dataSource = DataSource.shared
       
    if notification.name == DataFetchingResults.completedWithError {
      dataSource.initAppData()
      handleNotification(notification: notification.name)
      removeObservers()
    } else if notification.name == DataFetchingResults.completedSuccessfully {
      dataSource.initAppData()
      handleNotification(notification: notification.name)
      removeObservers()
    } else if notification.name == DataFetchingResults.authForbidden {
      handleNotification(notification: notification.name)
    } else if notification.name == DataFetchingResults.authUnauthorized {
      handleNotification(notification: notification.name)
    }
  }
  
  private func handleNotification(notification: NSNotification.Name) {
    
    if notification == DataFetchingResults.authForbidden {
      if CredentialManager.shared.userCredentialsInKeychainExists() {
        DataSource.shared.updateApiKey()
      } else {
        transitToNewScreenOnMainThread(notification: notification)
      }
    } else {
      transitToNewScreenOnMainThread(notification: notification)
    }
  }
  
  private func transitToNewScreenOnMainThread(notification: NSNotification.Name) {
    DispatchQueue.main.async {
      let newScreen = self.newScreen(for: notification)
      
      UIView.transition(with: self.window!,
                        duration: 0.3,
                        options: [.curveEaseIn, .transitionCrossDissolve],
                        animations: {
        let oldState: Bool = UIView.areAnimationsEnabled
        UIView.setAnimationsEnabled(false)
        self.window!.rootViewController = newScreen
        UIView.setAnimationsEnabled(oldState)
      })
    }
  }
  
  private func newScreen(for notification: NSNotification.Name) -> UIViewController {
    switch notification {
    case DataFetchingResults.completedSuccessfully:
      return MainTabBar(dataLoadedWithErrors: false)
    case DataFetchingResults.completedWithError:
      return MainTabBar(dataLoadedWithErrors: true)
    case DataFetchingResults.authUnauthorized:
      return LoginScreenVC()
    default:
      return UIViewController()
    }
  }
}
