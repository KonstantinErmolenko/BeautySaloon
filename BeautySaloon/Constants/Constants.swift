//
//  Constants.swift
//  BeautyShop
//
//  Created by Ермоленко Константин on 13.07.2020.
//  Copyright © 2020 Ермоленко Константин. All rights reserved.
//

import UIKit

typealias Schedule = [String: [Event]]
typealias EventData = [Int: [EventInfoRecord]]

enum SFSymbols {
  static let calendar = UIImage(systemName: "calendar")
  static let currency = UIImage(systemName: "rublesign.circle")
}

enum Colors {
  static let mainColor = UIColor(named: "mainColor")!
  static let eventColor = UIColor(named: "eventColor")!
  static let timelineBackground = UIColor(named: "timelineBackground")!
  static let shadowColor = UIColor(named: "shadowColor")!
  static let accentColor = UIColor(named: "accentColor")!
  static let color3 = UIColor(named: "Color3")!
  static let color4 = UIColor(named: "Color4")!
}
