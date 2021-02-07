//
//  DataManager.swift
//  BeautyShop
//
//  Created by Ермоленко Константин on 21.07.2020.
//  Copyright © 2020 Ермоленко Константин. All rights reserved.
//

import Foundation
import DateToolsSwift

struct DataManager {
  
  // MARK: - Public methods
  
  static func getDateList() -> [Date] {
    let now = currentDate()
    var dateList = [now]
    
    for i in 1...6 {
      dateList.append(now.add(i.days))
    }
    
    return dateList
  }
  
  static func currentDate() -> Date {
    let now = Date()
    
    return createDate(year: now.year, month: now.month, day: now.day)
  }
  
  // MARK: - Private methods
 
  private static func createDate(year: Int, month: Int, day: Int) -> Date {
    var dateComponents = DateComponents()
    dateComponents.year = year
    dateComponents.month = month
    dateComponents.day = day
    dateComponents.timeZone = .current
    
    let userCalendar = Calendar(identifier: .gregorian)
    if let date = userCalendar.date(from: dateComponents) {
      return date
    } else {
      return Date()
    }
  } 
}
