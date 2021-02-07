//
//  EventLayoutAttributes.swift
//  BeautyShop
//
//  Created by Ермоленко Константин on 27.09.2020.
//  Copyright © 2020 Ермоленко Константин. All rights reserved.
//

import UIKit

class EventLayoutAttributes {
  var event: Event
  var frame: CGRect = .zero
  
  init(_ event: Event) {
    self.event = event
  }
}
