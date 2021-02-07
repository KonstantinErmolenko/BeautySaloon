//
//  Event.swift
//  BeautyShop
//
//  Created by Ермоленко Константин on 19.07.2020.
//  Copyright © 2020 Ермоленко Константин. All rights reserved.
//

import Foundation

class Event: Codable {
  var id: String = ""
  var startDate = Date()
  var endDate = Date()
  var comment = ""
  var client: String = ""
  var services: [ServiceItem] = []
  var type: String = ""
  var isShort: Bool {
    return endDate.minutes(from: startDate) <= 60
  }
  var company = ""
  var creationDate = Date()
  var title = ""

  var servicesPresentation: String {
    var presentation = ""
    
    if isShort {
      if let firstService = services.first  {
        presentation += "\(firstService.service)..."
      }
    } else {
      for index in 0..<services.count {
        let service = services[index]
        let prefix = index == 0 ? "" : "\n"
        presentation += prefix + "\(service.service)"
      }
    }
    
    return presentation
  }
}

struct ServiceItem: Codable {
  let service: String
  let cost: Double
  let quantity: Int
}
