//
//  DaySymbolsView.swift
//  BeautyShop
//
//  Created by Ермоленко Константин on 16.09.2020.
//  Copyright © 2020 Ермоленко Константин. All rights reserved.
//

import UIKit

protocol DaySymbolsDelegate: AnyObject {
  func dateDidSelected(date: Date)
}

class DaySymbolsView: UIView {
  
  // MARK: - Public properties
  
  var delegate: DaySymbolsDelegate?
  
  // MARK: - Private properties
  
  private var daySymbols = [DaySymbol]()
  private var calendar = Calendar.autoupdatingCurrent
  private var daysInWeek = 7
  private var stackView = UIStackView()
  private var currentDate = Date()
  private let dateFormatter = DateFormatter()
  
  // MARK: - Initialization
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupDateFormatter()
    createDaySymbols()
    configureStackView()
    setCurrentDate(at: DataManager.currentDate())
    translatesAutoresizingMaskIntoConstraints = false
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Public methods
  
  func setCurrentDate(at date: Date) {
    currentDate = date
    
    for symbol in daySymbols {
      if symbol.date == currentDate {
        symbol.setStyle(selectionStyle: .selected)
      } else {
        symbol.setStyle(selectionStyle: .unselected)
      }
    }
  }
  
  // MARK: - Configuring methods
  
  private func setupDateFormatter() {
    dateFormatter.locale = Locale(identifier: "ru_RU")
  }
  
  private func createDaySymbols() {
    let dateList = DataManager.getDateList()
    
    for index in 0..<daysInWeek {
      let date = dateList[index]
      let daySymbol = DaySymbol(date: date, formatter: dateFormatter)
      daySymbols.append(daySymbol)
      
      let recognizer = UITapGestureRecognizer(target: self,
                                              action: #selector(daySymbolDidTap(_:)))
      daySymbol.addGestureRecognizer(recognizer)
    }
  }
  
  private func configureStackView() {
    addSubview(stackView)
    for day in daySymbols {
      stackView.addArrangedSubview(day)
    }
    
    stackView.axis = .horizontal
    stackView.distribution = .fillEqually
    stackView.spacing = 6
    let margins: CGFloat = 2
    stackView.layoutMargins = UIEdgeInsets(top: 0, left: margins, bottom: 0, right: margins)
    stackView.isLayoutMarginsRelativeArrangement = true
    stackView.pinToEdges(of: self)
  }
  
  // MARK: - Private methods
  
  @objc private func daySymbolDidTap(_ sender: UITapGestureRecognizer) {
    if let item = sender.view as? DaySymbol {
      delegate?.dateDidSelected(date: item.date)
    }
  }
}
