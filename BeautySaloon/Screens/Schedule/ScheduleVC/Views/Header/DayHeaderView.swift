//
//  DayHeaderView.swift
//  BeautyShop
//
//  Created by Ермоленко Константин on 13.09.2020.
//  Copyright © 2020 Ермоленко Константин. All rights reserved.
//

import UIKit

protocol DayHeaderViewDelegate: AnyObject {
  func masterLabelDidTap()
}

class DayHeaderView: UIView {
  
  // MARK: - Public properties
  
  var delegate: DayHeaderViewDelegate?
  let calendar: Calendar
  weak var state: DayViewState? {
    willSet {
      state?.unsubscribe(client: self)
    }
    didSet {
      state?.subscribe(client: self)
    }
  }
  
  // MARK: - Private properties
  
  let daySymbolsView: DaySymbolsView
  let dateLabel: BSTitleLabel!
  let quantityLabel: BSSecondaryTitleLable!
  let masterLabel: CurrentMasterLabel!

  // MARK: - Initialization
  
  init(calendar: Calendar) {
    self.calendar = calendar
    daySymbolsView = DaySymbolsView()
    dateLabel = BSTitleLabel(textAlignment: .left, fontSize: 17)
    quantityLabel = BSSecondaryTitleLable(textAlignment: .left, fontSize: 14)
    masterLabel = CurrentMasterLabel(textAlignment: .right,
                                            fontSize: 17,
                                            lineBreakMode: .byWordWrapping)
    super.init(frame: .zero)
    configure()
  }
  
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Public methods
  
  func update(withInfo info: DayInfo) {
    dateLabel.text = info.date.convertToDayMonthFormat()
    quantityLabel.text = "Клиентов \(info.numberOfClients)"
  }
    
  func setMaster(name: String) {
    masterLabel.text = name
  }
  
  // MARK: - Configuring methods
  
  private func configure() {
    translatesAutoresizingMaskIntoConstraints = false
    layoutElements()
    backgroundColor = Colors.mainColor
    daySymbolsView.delegate = self
    
    masterLabel.text = "userInfo.username"
    
    setupMasterLabelTap()
  }
  
  private func layoutElements() {
    addSubviews(
      dateLabel,
      quantityLabel,
      masterLabel,
      daySymbolsView
    )
    
    let paddingV: CGFloat = 8
    let paddingH: CGFloat = 20

    NSLayoutConstraint.activate([
      dateLabel.topAnchor.constraint(equalTo: topAnchor,
                                     constant: paddingV),
      dateLabel.heightAnchor.constraint(equalToConstant: 25),
      dateLabel.leadingAnchor.constraint(equalTo: leadingAnchor,
                                         constant: paddingH),
      dateLabel.trailingAnchor.constraint(equalTo: centerXAnchor,
                                          constant: -2),

      quantityLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor,
                                         constant: paddingV+3),
      quantityLabel.heightAnchor.constraint(equalToConstant: 20),
      quantityLabel.leadingAnchor.constraint(equalTo: leadingAnchor,
                                             constant: paddingH),
      quantityLabel.trailingAnchor.constraint(equalTo: centerXAnchor,
                                              constant: -2),
      
      masterLabel.topAnchor.constraint(equalTo: topAnchor,
                                       constant: paddingV),
      masterLabel.bottomAnchor.constraint(equalTo: quantityLabel.bottomAnchor),
      masterLabel.leadingAnchor.constraint(equalTo: centerXAnchor,
                                           constant: 2),
      masterLabel.trailingAnchor.constraint(equalTo: trailingAnchor,
                                            constant: -paddingH),
      
      daySymbolsView.topAnchor.constraint(equalTo: quantityLabel.bottomAnchor,
                                         constant: paddingV),
      daySymbolsView.heightAnchor.constraint(equalToConstant: 78),
      daySymbolsView.leadingAnchor.constraint(equalTo: leadingAnchor,
                                             constant: paddingH),
      daySymbolsView.trailingAnchor.constraint(equalTo: trailingAnchor,
                                              constant: -paddingH),
    ])
  }
  
  private func setupMasterLabelTap() {
    let tapRecognizer = UITapGestureRecognizer(target: self,
                                               action: #selector(self.masterLabelDidTap(_:)))
    masterLabel.isUserInteractionEnabled = true
    masterLabel.addGestureRecognizer(tapRecognizer)
  }
  
  @objc func masterLabelDidTap(_ sender: UITapGestureRecognizer) {
    delegate?.masterLabelDidTap()
  }
}

// MARK: - DayViewStateUpdating

extension DayHeaderView: DayViewStateUpdating {
  func dateDidSelected(from oldDate: Date, to newDate: Date) {
    daySymbolsView.setCurrentDate(at: newDate)
  }
  
  func scheduleDidUpdated() {}
}

// MARK: - DaySybolsDelegate

extension DayHeaderView: DaySymbolsDelegate {
  func dateDidSelected(date: Date) {
    state?.updateCurrentDate(newDate: date)
  }
}
