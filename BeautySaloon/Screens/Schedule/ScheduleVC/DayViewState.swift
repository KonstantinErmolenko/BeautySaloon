//
//  DayViewState.swift
//  BeautyShop
//
//  Created by Ермоленко Константин on 24.09.2020.
//  Copyright © 2020 Ермоленко Константин. All rights reserved.
//

import Foundation

protocol DayViewStateUpdating: AnyObject {
  func dateDidSelected(from oldDate: Date, to newDate: Date)
  func scheduleDidUpdated()
}

class DayViewState {
  
  // MARK: - Public properties
  
  private(set) var currentDate = Date()

  // MARK: - Private properties
  
  private var calendar: Calendar
  private var clients = [DayViewStateUpdating]()
  
  // MARK: - Initialization
  
  init(date: Date = Date(), calendar: Calendar = Calendar.autoupdatingCurrent) {
    let date = date.dateOnly(calendar: calendar)
    self.calendar = calendar
    self.currentDate = date
  }
  
  // MARK: - Public methods
  
  func subscribe(client: DayViewStateUpdating) {
    clients.append(client)
  }
  
  func unsubscribe(client: DayViewStateUpdating) {
    clients = allClientsWithout(client: client)
  }
  
  func updateCurrentDate(newDate: Date) {
    let date = newDate.dateOnly(calendar: calendar)
    notifyCurrentDateDidUpdated(clients: clients, newDate: date)
    currentDate = date
  }
  
  func notifyscheduleDidUpdated() {
    notifyscheduleDidUpdated(clients: clients)
  }
  
  func client(client: DayViewStateUpdating, didMoveTo date: Date) {
    let date = date.dateOnly(calendar: calendar)
    notifyCurrentDateDidUpdated(clients: allClientsWithout(client: client), newDate: date)
    currentDate = date
  }
  
  // MARK: - Private methods
  
  private func notifyCurrentDateDidUpdated(clients: [DayViewStateUpdating], newDate: Date) {
    for client in clients {
      client.dateDidSelected(from: currentDate, to: newDate)
    }
  }

  private func notifyscheduleDidUpdated(clients: [DayViewStateUpdating]) {
    for client in clients {
      client.scheduleDidUpdated()
    }
  }
  
  private func allClientsWithout(client: DayViewStateUpdating) -> [DayViewStateUpdating] {
    return clients.filter { $0 !== client }
  }
}
