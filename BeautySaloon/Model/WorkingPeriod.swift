//
//  WorkingPeriod.swift
//  BeautyShop
//
//  Created by Ермоленко Константин on 19.11.2020.
//  Copyright © 2020 Ермоленко Константин. All rights reserved.
//

import Foundation

struct WorkingPeriod {
  
  // MARK: - Public properties
  
  let start: Date
  let end: Date
  var length: Int {
    hours.count
  }
  private(set) var hours: [Int]
  
  // MARK: - Private properties

  private let calendar = DateManager.calendar

  // MARK: - Initialization
  
  init(start: Date, end: Date) {
    self.start = start
    self.end = end

    hours = [Int]()
    let dateInterval = DateInterval(start: start, end: end)
    let duration = Int(dateInterval.duration)
    let hoursCount = duration / 3600
    let shift = shiftInHours(date: start)
    
    for hour in 0...hoursCount {
      hours.append(hour + shift)
    }
  }
  
  private func shiftInHours(date: Date) -> Int {
    let components = calendar.dateComponents([Calendar.Component.hour],
                                             from: date)
    if let shift = components.hour {
      return shift
    }
    return 0
  }
}
