//
//  ServicesLabel.swift
//  BeautyShop
//
//  Created by Ермоленко Константин on 10.01.2021.
//  Copyright © 2021 Ермоленко Константин. All rights reserved.
//

import UIKit

class ServicesLabel: UILabel {
  
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
  
  override func drawText(in rect: CGRect) {
    guard let string = text else {
      super.drawText(in: rect)
      return
    }
    
    let size = (string as NSString).boundingRect(
      with: CGSize(width: rect.width, height: .greatestFiniteMagnitude),
      options: [.usesLineFragmentOrigin],
      attributes: [.font: font!],
      context: nil).size
    
    var rect = rect
    rect.size.height = size.height.rounded()
    super.drawText(in: rect)
  }
  
  // MARK: - Configuring methods
  
  private func configue() {
    textColor = .secondaryLabel
    adjustsFontSizeToFitWidth = true
    minimumScaleFactor = 0.9
    lineBreakMode = .byTruncatingTail
    translatesAutoresizingMaskIntoConstraints = false
  }
}
