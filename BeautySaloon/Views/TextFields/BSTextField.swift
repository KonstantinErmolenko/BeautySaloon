//
//  BSTextField.swift
//  BeautyShop
//
//  Created by Ермоленко Константин on 26.11.2020.
//  Copyright © 2020 Ермоленко Константин. All rights reserved.
//

import UIKit

class BSTextField: UITextField {
  
  init() {
    super.init(frame: .zero)
    configure()
  }
  
  init(placeholder: String) {
    super.init(frame: .zero)
    self.placeholder = placeholder
    configure()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func configure() {
    layer.borderWidth = 1.1
    layer.borderColor = Colors.accentColor.cgColor
    layer.cornerRadius = 6
    leftView = UIView(frame: CGRect(x: 0, y: 0,width: 15, height: frame.height))
    leftViewMode = .always
  }
}
