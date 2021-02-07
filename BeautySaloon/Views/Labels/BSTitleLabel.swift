//
//  BSTitleLabel.swift
//  BeautyShop
//
//  Created by Ермоленко Константин on 14.07.2020.
//  Copyright © 2020 Ермоленко Константин. All rights reserved.
//

import UIKit

class BSTitleLabel: UILabel {
  
  // MARK: - Initialization
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    configue()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  convenience init(textAlignment: NSTextAlignment, fontSize: CGFloat) {
    self.init(frame: .zero)
    self.textAlignment = textAlignment
    font = UIFont.systemFont(ofSize: fontSize, weight: .bold)
  }
  
  // MARK: - Configuring methods
  
  private func configue() {
    textColor = .label
    adjustsFontSizeToFitWidth = true
    minimumScaleFactor = 0.9
    lineBreakMode = .byTruncatingTail  
    translatesAutoresizingMaskIntoConstraints = false
  }
}
