//
//  CurrentMasterLabel.swift
//  BeautyShop
//
//  Created by Ермоленко Константин on 23.01.2021.
//  Copyright © 2021 Ермоленко Константин. All rights reserved.
//

import UIKit

class CurrentMasterLabel: UILabel {
  
  // MARK: - Initialization
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    configue()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  convenience init(textAlignment: NSTextAlignment,
                   fontSize: CGFloat,
                   lineBreakMode: NSLineBreakMode) {
    self.init(frame: .zero)
    self.textAlignment = textAlignment
    self.lineBreakMode = lineBreakMode
    font = UIFont.systemFont(ofSize: fontSize, weight: .semibold)
  }
    
  // MARK: - Override methods
  
  override func drawText(in rect:CGRect) {
    guard let labelText = text else { return super.drawText(in: rect) }
    
    let attributedText = NSAttributedString(string: labelText,
                                            attributes: [NSAttributedString.Key.font: font!])
    var newRect = rect
    newRect.size.height = attributedText.boundingRect(with: rect.size,
                                                      options: .usesLineFragmentOrigin,
                                                      context: nil).size.height
    
    if numberOfLines != 0 {
      newRect.size.height = min(newRect.size.height, CGFloat(numberOfLines) * font.lineHeight)
    }
    
    super.drawText(in: newRect)
  }

  // MARK: - Configuring methods
  
  private func configue() {
    textColor = Colors.accentColor
    adjustsFontSizeToFitWidth = true
    minimumScaleFactor = 0.9
    translatesAutoresizingMaskIntoConstraints = false
  }
}
