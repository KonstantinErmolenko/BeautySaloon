//
//  DateManager.swift
//  BeautyShop
//
//  Created by Ермоленко Константин on 19.11.2020.
//  Copyright © 2020 Ермоленко Константин. All rights reserved.
//

import Foundation
import DateToolsSwift

class DateManager {
  
  // MARK: - Public properties
  
  static let shared = DateManager()
  static let calendar = Calendar.autoupdatingCurrent
  
  let workingPeriod: WorkingPeriod

  // MARK: - Private properties
  
  private var formatter: DateFormatter
  
  // MARK: - Initialization
  
  private init() {
    self.formatter = DateManager.configureFormatter()
    self.workingPeriod = DateManager.configureWorkingPeriod(formatter: self.formatter)
  }

  // MARK: - Private methods
  
  static private func configureFormatter() -> DateFormatter {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    formatter.locale = .current
    
    return formatter
  }

  static private func configureWorkingPeriod(formatter: DateFormatter) -> WorkingPeriod {
    let startDate = formatter.date(from: "2020-11-19T07:00:00Z")!
    let endDate = formatter.date(from: "2020-11-19T16:00:00Z")!
    
    return WorkingPeriod(start: startDate, end: endDate)
  }
}
