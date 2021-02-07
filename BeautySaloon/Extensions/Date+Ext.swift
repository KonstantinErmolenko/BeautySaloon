//
//  Date+Ext.swift
//  BeautyShop
//
//  Created by Ермоленко Константин on 19.07.2020.
//  Copyright © 2020 Ермоленко Константин. All rights reserved.
//

import Foundation

extension Date {
  func convertToMonthYearFormat() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "ru_RU")
    dateFormatter.dateFormat = "MMMM yyyy"
    
    return dateFormatter.string(from: self)
  }
  
  func convertToDayMonthFormat() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "ru_RU")
    dateFormatter.dateFormat = "d MMMM"
    
    return dateFormatter.string(from: self)
  }
  
  func convertToDayTimeFormat() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "ru_RU")
    dateFormatter.dateFormat = "d MMMM HH:mm"
    
    return dateFormatter.string(from: self)
  }
  
  func convertToYearMounthDay() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "ru_RU")
    dateFormatter.dateFormat = "yyyy-MM-dd"
    
    return dateFormatter.string(from: self)
  }
  
  func shortTimeFormat() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "ru_RU")
    dateFormatter.dateFormat = "HH:mm"
    
    return dateFormatter.string(from: self)
  }
  
  func dateOnly(calendar: Calendar) -> Date {
    let year = calendar.component(.year, from: self)
    let month = calendar.component(.month, from: self)
    let day = calendar.component(.day, from: self)
    let zone = calendar.timeZone
    let newComponents = DateComponents(timeZone: zone, year: year, month: month, day: day)
    let returnValue = calendar.date(from: newComponents)
    
    return returnValue!
  }

  func getISOTimestamp(_ options: ISO8601DateFormatter.Options) -> String {
    let isoDateFormatter = ISO8601DateFormatter()
    isoDateFormatter.timeZone = .autoupdatingCurrent
    isoDateFormatter.formatOptions = options
    let timestamp = isoDateFormatter.string(from: self)
    return timestamp
  }
}

extension Date {
    /// Returns the amount of years from another date
    func years(from date: Date) -> Int {
        return Calendar.current.dateComponents([.year], from: date, to: self).year ?? 0
    }
    /// Returns the amount of months from another date
    func months(from date: Date) -> Int {
        return Calendar.current.dateComponents([.month], from: date, to: self).month ?? 0
    }
    /// Returns the amount of weeks from another date
    func weeks(from date: Date) -> Int {
        return Calendar.current.dateComponents([.weekOfMonth], from: date, to: self).weekOfMonth ?? 0
    }
    /// Returns the amount of days from another date
    func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    /// Returns the amount of hours from another date
    func hours(from date: Date) -> Int {
        return Calendar.current.dateComponents([.hour], from: date, to: self).hour ?? 0
    }
    /// Returns the amount of minutes from another date
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    /// Returns the amount of seconds from another date
    func seconds(from date: Date) -> Int {
        return Calendar.current.dateComponents([.second], from: date, to: self).second ?? 0
    }
    /// Returns the a custom time interval description from another date
    func offset(from date: Date) -> String {
        if years(from: date)   > 0 { return "\(years(from: date))y"   }
        if months(from: date)  > 0 { return "\(months(from: date))M"  }
        if weeks(from: date)   > 0 { return "\(weeks(from: date))w"   }
        if days(from: date)    > 0 { return "\(days(from: date))d"    }
        if hours(from: date)   > 0 { return "\(hours(from: date))h"   }
        if minutes(from: date) > 0 { return "\(minutes(from: date))m" }
        if seconds(from: date) > 0 { return "\(seconds(from: date))s" }
        return ""
    }
}
