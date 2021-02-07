//
//  UIView+Ext.swift
//  BeautyShop
//
//  Created by Ермоленко Константин on 20.10.2020.
//  Copyright © 2020 Ермоленко Константин. All rights reserved.
//

import UIKit

extension UIView {
  func addSubviews(_ views: UIView...) {
    for view in views { addSubview(view) }
  }
  
  func pinToEdges(of superview: UIView) {
    translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      topAnchor.constraint(equalTo: superview.topAnchor),
      leadingAnchor.constraint(equalTo: superview.leadingAnchor),
      trailingAnchor.constraint(equalTo: superview.trailingAnchor),
      bottomAnchor.constraint(equalTo: superview.bottomAnchor)
    ])
  }
}

extension UIView {
  
  func fadeIn(duration: TimeInterval = 0.5, delay: TimeInterval = 0.0, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in }) {
    self.alpha = 0.0
    
    UIView.animate(withDuration: duration, delay: delay, options: .curveEaseIn, animations: {
      self.isHidden = false
      self.alpha = 1.0
    }, completion: completion)
  }
  
  func fadeOut(duration: TimeInterval = 0.5, delay: TimeInterval = 0.0, completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in }) {
    self.alpha = 1.0
    
    UIView.animate(withDuration: duration, delay: delay, options: .curveEaseIn, animations: {
      self.alpha = 0.0
    }) { (completed) in
      self.isHidden = true
      completion(true)
    }
  }
}

