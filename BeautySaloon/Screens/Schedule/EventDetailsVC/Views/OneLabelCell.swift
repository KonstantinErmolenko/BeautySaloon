//
//  OneLabelCell.swift
//  BeautyShop
//
//  Created by Ермоленко Константин on 14.01.2021.
//  Copyright © 2021 Ермоленко Константин. All rights reserved.
//

import UIKit

class OneLabelCell: UITableViewCell {

  // MARK: - Public properties

  static let reuseID = "serviceCell"

  // MARK: - Private properties

  let serviceLabel = BSCellLabel(fontSize: 14,
                                 textAlignment: .center,
                                 weight: .bold)

  // MARK: - Initialization

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    configue()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Public methods

  func set(withInfo info: EventInfoRecord) {
    serviceLabel.text = info.value
    
    switch info.key {
    case "Мастер":
      separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: UIScreen.main.bounds.width)
      
    case "Работа":
      serviceLabel.textAlignment = .left
      self.backgroundColor = Colors.timelineBackground

    case "Комментарий":
      serviceLabel.textAlignment = .left
      serviceLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
      
    default:
      return
    }
  }
  
  // MARK: - Configuring methods

  private func configue() {
    backgroundColor = Colors.eventColor
    
    addSubview(serviceLabel)
    
    let padding: CGFloat = 16
    NSLayoutConstraint.activate([
      serviceLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor,
                                            constant: padding),
      serviceLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor,
                                             constant: -padding),
      serviceLabel.topAnchor.constraint(equalTo: self.topAnchor),
      serviceLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
    ])
  }
}
