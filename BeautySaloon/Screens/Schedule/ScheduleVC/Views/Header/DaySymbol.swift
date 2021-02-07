//
//  DaySymbol.swift
//  BeautyShop
//
//  Created by Ермоленко Константин on 17.09.2020.
//  Copyright © 2020 Ермоленко Константин. All rights reserved.
//

import UIKit

class DaySymbol: UIView {
  
  // MARK: - Public properties
  
  private(set) var date: Date
  
  // MARK: - Private properties
  
  private var weekdayLabel = DaySymbolLabel(textAlignment: .center, fontSize: 16)
  private var dayNumberLabel = DaySymbolLabel(textAlignment: .center, fontSize: 16)
  private var calendar = Calendar.autoupdatingCurrent
  private unowned var formatter: DateFormatter
  
  // MARK: - Initialization
  
  init(date: Date, formatter: DateFormatter) {
    self.date = date
    self.formatter = formatter
    super.init(frame: .zero)
    configure()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Public methods
  
  func setStyle(selectionStyle: DaySymbolSelectionStyle) {
    switch selectionStyle {
    case .selected:
      layer.borderWidth = 2.4
      layer.borderColor = Colors.accentColor.cgColor
      backgroundColor = Colors.eventColor
      
    case .unselected:
      layer.borderWidth = 1
      layer.borderColor = Colors.mainColor.cgColor
      backgroundColor = Colors.mainColor
    }
    
    weekdayLabel.setStyle(selectionStyle: selectionStyle)
    dayNumberLabel.setStyle(selectionStyle: selectionStyle)
  }
  
  // MARK: - Configuring methods
  
  private func configure() {
    layer.cornerRadius = 9
    backgroundColor = Colors.mainColor
    layoutElements()
    populateDayInfo()
  }
  
  private func populateDayInfo() {
    let dayOfWeek = calendar.component(.weekday, from: date)
    weekdayLabel.text = formatter.shortWeekdaySymbols[dayOfWeek - 1]
    dayNumberLabel.text = String(date.component(.day))
  }
  

  
  private func layoutElements() {
    addSubview(weekdayLabel)
    addSubview(dayNumberLabel)
    
    NSLayoutConstraint.activate([
      weekdayLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
      weekdayLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 4),
      weekdayLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -4),
      
      dayNumberLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16),
      dayNumberLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor)
    ])
  }
}
