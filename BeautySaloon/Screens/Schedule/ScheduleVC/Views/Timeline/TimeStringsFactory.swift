//
//  TimeStringsFactory.swift
//  BeautyShop
//
//  Created by Ермоленко Константин on 21.07.2020.
//  Copyright © 2020 Ермоленко Константин. All rights reserved.
//

import Foundation

struct TimeStringsFactory {
  
  // MARK: - Properties
  
  private let calendar: Calendar
  
  // MARK: - Initialization
  
  init(_ calendar: Calendar = Calendar.autoupdatingCurrent) {
    self.calendar = calendar
  }
  
  // MARK: - Public methods
  
  func make24hStrings(for workingPeriod: WorkingPeriod) -> [String] {
    var numbers = [String]()
    
    for hour in workingPeriod.hours {
      let hour = hour % 24
      var string = hour < 10 ? "0" + String(hour) : String(hour)
      string.append(":00")
      numbers.append(string)
    }
    
    return numbers
  }
}
