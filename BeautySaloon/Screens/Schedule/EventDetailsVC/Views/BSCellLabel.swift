//
//  BSCellLabel.swift
//  BeautyShop
//
//  Created by Ермоленко Константин on 14.01.2021.
//  Copyright © 2021 Ермоленко Константин. All rights reserved.
//

import UIKit

class BSCellLabel: UILabel {
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    configue()
  }
  
  convenience init(fontSize: CGFloat,
                   textAlignment: NSTextAlignment = .left,
                   weight: UIFont.Weight = .regular) {
    self.init(frame: .zero)
    self.font = UIFont.systemFont(ofSize: fontSize, weight: weight)
    self.textAlignment = textAlignment
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func configue() {
    lineBreakMode = .byTruncatingTail
    translatesAutoresizingMaskIntoConstraints = false
  }
}
