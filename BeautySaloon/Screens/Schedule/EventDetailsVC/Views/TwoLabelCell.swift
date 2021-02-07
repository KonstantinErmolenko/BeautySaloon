//
//  TwoLabelCell.swift
//  BeautyShop
//
//  Created by Ермоленко Константин on 14.01.2021.
//  Copyright © 2021 Ермоленко Константин. All rights reserved.
//

import UIKit

class TwoLabelCell: UITableViewCell {
  
  // MARK: - Public properties

  static let reuseID = "detailCell"

  // MARK: - Private properties

  let keyLabel = BSCellLabel(fontSize: 14)
  let valueLabel = BSCellLabel(fontSize: 14, textAlignment: .right)

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
    keyLabel.text = info.key
    valueLabel.text = info.value
  }
  
  // MARK: - Configuring methods

  private func configue() {
    addSubviews(keyLabel, valueLabel)
    
    backgroundColor = Colors.eventColor

    let padding: CGFloat = 16
    NSLayoutConstraint.activate([
      keyLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
      keyLabel.widthAnchor.constraint(equalToConstant: 130),
      keyLabel.topAnchor.constraint(equalTo: self.topAnchor),
      keyLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
      
      valueLabel.leadingAnchor.constraint(equalTo: keyLabel.trailingAnchor, constant: 2),
      valueLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
      valueLabel.topAnchor.constraint(equalTo: self.topAnchor),
      valueLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
    ])
  }
}
