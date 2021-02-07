//
//  TimelineStyle.swift
//  BeautyShop
//
//  Created by Ермоленко Константин on 10.01.2021.
//  Copyright © 2021 Ермоленко Константин. All rights reserved.
//

import UIKit

struct TimelineStyle {
  var timeColor = UIColor.secondaryLabel
  var lineColor = UIColor.quaternaryLabel
  var backgroundColor = Colors.timelineBackground
  var font = UIFont.boldSystemFont(ofSize: 12)
  var splitMinuteInterval: Int = 15
  var verticalDiff: CGFloat = 100
  var verticalInset: CGFloat = 12
  var leftInset: CGFloat = 65
  var rightInset: CGFloat = 25
  init() {}
}
