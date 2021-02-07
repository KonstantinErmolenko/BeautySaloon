//
//  String+Ext.swift
//  BeautyShop
//
//  Created by Ермоленко Константин on 15.11.2020.
//  Copyright © 2020 Ермоленко Константин. All rights reserved.
//

import Foundation

extension String {
  func dateFromISO8601String() -> Date? {
    let dateFormatter = ISO8601DateFormatter()
    let date = dateFormatter.date(from: self)!
    
    return date
  }
}
