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
  static let timeRange = 0...24
  
  static func getDateList() -> [Date] {
    let now      = currentDate()
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
  
  private static func createDate(year: Int, month: Int, day: Int) -> Date {
    var dateComponents = DateComponents()
    dateComponents.year     = year
    dateComponents.month    = month
    dateComponents.day      = day
    dateComponents.timeZone = TimeZone(abbreviation: "MSK") // Moscow Standard Time
    
    let userCalendar = Calendar(identifier: .gregorian)
    if let date = userCalendar.date(from: dateComponents) {
      return date
    } else {
      return Date()
    }
  }
  
  struct EventMock {
    let startTime: DateComponents
    let endTime: DateComponents
    let text: String
  }
  
  static func eventsByDays() -> [Int : [EventMock]] {
    var mocks: [Int : [EventMock]] = [:]
    
    mocks[0] = [EventMock(startTime: DateComponents(hour: 9, minute: 0),
                          endTime: DateComponents(hour: 10, minute: 30),
                          text: "date1-event1"),
                EventMock(startTime: DateComponents(hour: 11, minute: 0),
                          endTime: DateComponents(hour: 12, minute: 30),
                          text: "date1-event2"),
                EventMock(startTime: DateComponents(hour: 13, minute: 45),
                          endTime: DateComponents(hour: 14, minute: 30),
                          text: "date1-event3")
    ]
    mocks[1] = [EventMock(startTime: DateComponents(hour: 11, minute: 0),
                          endTime: DateComponents(hour: 11, minute: 50),
                          text: "date2-event1"),
                EventMock(startTime: DateComponents(hour: 12, minute: 0),
                          endTime: DateComponents(hour: 13, minute: 15),
                          text: "date2-event2"),
                EventMock(startTime: DateComponents(hour: 14, minute: 0),
                          endTime: DateComponents(hour: 15, minute: 45),
                          text: "date2-event3")
    ]
    mocks[2] = [EventMock(startTime: DateComponents(hour: 9, minute: 0),
                          endTime: DateComponents(hour: 10, minute: 30),
                          text: "date3-event1"),
                EventMock(startTime: DateComponents(hour: 11, minute: 0),
                          endTime: DateComponents(hour: 12, minute: 30),
                          text: "date3-event2"),
                EventMock(startTime: DateComponents(hour: 13, minute: 45),
                          endTime: DateComponents(hour: 14, minute: 30),
                          text: "date3-event3")
    ]
    mocks[3] = [EventMock(startTime: DateComponents(hour: 9, minute: 0),
                          endTime: DateComponents(hour: 10, minute: 30),
                          text: "date4-event1"),
                EventMock(startTime: DateComponents(hour: 11, minute: 0),
                          endTime: DateComponents(hour: 12, minute: 30),
                          text: "date4-event2"),
                EventMock(startTime: DateComponents(hour: 13, minute: 45),
                          endTime: DateComponents(hour: 14, minute: 30),
                          text: "date4-event3")
    ]
    mocks[4] = [EventMock(startTime: DateComponents(hour: 9, minute: 0),
                          endTime: DateComponents(hour: 10, minute: 30),
                          text: "date5-event1"),
                EventMock(startTime: DateComponents(hour: 11, minute: 0),
                          endTime: DateComponents(hour: 12, minute: 30),
                          text: "date5-event2"),
                EventMock(startTime: DateComponents(hour: 13, minute: 45),
                          endTime: DateComponents(hour: 14, minute: 30),
                          text: "date5-event3")
    ]
    mocks[5] = [EventMock(startTime: DateComponents(hour: 9, minute: 0),
                          endTime: DateComponents(hour: 10, minute: 30),
                          text: "date6-event1"),
                EventMock(startTime: DateComponents(hour: 11, minute: 0),
                          endTime: DateComponents(hour: 12, minute: 30),
                          text: "date6-event2"),
                EventMock(startTime: DateComponents(hour: 13, minute: 45),
                          endTime: DateComponents(hour: 14, minute: 30),
                          text: "date6-event3")
    ]
    mocks[6] = [EventMock(startTime: DateComponents(hour: 9, minute: 0),
                          endTime: DateComponents(hour: 10, minute: 30),
                          text: "date7-event1"),
                EventMock(startTime: DateComponents(hour: 11, minute: 0),
                          endTime: DateComponents(hour: 12, minute: 30),
                          text: "date7-event2"),
                EventMock(startTime: DateComponents(hour: 13, minute: 45),
                          endTime: DateComponents(hour: 14, minute: 30),
                          text: "date7-event3")
    ]
    
    return mocks
  }
}
