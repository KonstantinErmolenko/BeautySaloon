//
//  DaySymbolLabel.swift
//  BeautyShop
//
//  Created by Ермоленко Константин on 10.01.2021.
//  Copyright © 2021 Ермоленко Константин. All rights reserved.
//

import UIKit

class DaySymbolLabel: UILabel {
  
  // MARK: - Private properties
  
  var selected = false
  
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
    font = UIFont.systemFont(ofSize: fontSize, weight: .medium)
  }
  
  // MARK: - Public methods

  func setStyle(selectionStyle: DaySymbolSelectionStyle) {
    switch selectionStyle {
    case .selected:
      textColor = .label

    case .unselected:
      textColor = Colors.color3
    }
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
