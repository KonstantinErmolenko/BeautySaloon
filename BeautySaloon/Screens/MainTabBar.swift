//
//  MainTabBarController.swift
//  BeautyShop
//
//  Created by Ермоленко Константин on 13.07.2020.
//  Copyright © 2020 Ермоленко Константин. All rights reserved.
//

import UIKit

class MainTabBar: UITabBarController {
  
  // MARK: - Public properties
  
  var dataLoadedWithErrors: Bool!
  
  // MARK: - Initialization
  
  init(dataLoadedWithErrors: Bool) {
    super.init(nibName: nil, bundle: nil)
    self.dataLoadedWithErrors = dataLoadedWithErrors
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Lyfecycle methods
  
  override func viewDidLoad() {
    super.viewDidLoad()
    UITabBar.appearance().tintColor = Colors.accentColor
    populateViewControllers()
  }
  
  override func viewDidLayoutSubviews() {
    if dataLoadedWithErrors {
      dataLoadedWithErrors = false
      showDataFetchingErrorAlert()
    }
  }
  
  // MARK: - Private methods
  
  private func populateViewControllers() {
    let scheduleVC = ScheduleVC()
    scheduleVC.tabBarItem  = UITabBarItem(title: "Расписание",
                                          image: SFSymbols.calendar, tag: 0)
    
    let payrollVC = PayrolltVC()
    payrollVC.tabBarItem = UITabBarItem(title: "Начисления",
                                        image: SFSymbols.currency, tag: 1)
    
    viewControllers = [UINavigationController(rootViewController: scheduleVC),
                       UINavigationController(rootViewController: payrollVC)]
  }

  private func showDataFetchingErrorAlert() {
    DispatchQueue.main.async {
      let alertController = UIAlertController(
        title: "Ошибка подключения",
        message: "Не удалось обновить расписание. Текущие данные могут быть неактуальны.",
        preferredStyle: .actionSheet
      )
      let alertAction = UIAlertAction(title: "Ok", style: .cancel)
      alertController.addAction(alertAction)
      self.present(alertController, animated: true, completion: nil)
    }
  }
}
