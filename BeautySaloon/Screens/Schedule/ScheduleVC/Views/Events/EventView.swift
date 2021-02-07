//
//  EventView.swift
//  BeautyShop
//
//  Created by Ермоленко Константин on 27.09.2020.
//  Copyright © 2020 Ермоленко Константин. All rights reserved.
//

import UIKit

class EventView: UIView {
  
  // MARK: - Public properties
  
  var id: String!
  let clientLabel = BSTitleLabel(textAlignment: .left, fontSize: 16)
  let servicesLabel = ServicesLabel(textAlignment: .left, fontSize: 14)
  let timeLabel = BSSecondaryTitleLable(textAlignment: .left, fontSize: 14)
  let commentIco = UIImageView()

  // MARK: - Initialization
  
  init() {
    super.init(frame: .zero)
    configure()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Override methods
  
  override func draw(_ rect: CGRect) {
    addShadow()
  }
  
  // MARK: - Public methods
  
  func update(with event: Event) {
    id = event.id
    
    clientLabel.text = event.client
    servicesLabel.text = event.servicesPresentation
    servicesLabel.numberOfLines = 0
    timeLabel.text = "\(event.startDate.shortTimeFormat()) - \(event.endDate.shortTimeFormat())"

    if !event.comment.isEmpty {
      let commentImage = UIImage(systemName: "message.fill")
      commentIco.image = commentImage
      commentIco.contentMode = .scaleAspectFit
      commentIco.tintColor = Colors.accentColor
    } else {
      commentIco.isHidden = true
    }
    
    setNeedsDisplay()
    setNeedsLayout()
  }
  
  // MARK: - Private methods
  
  func layoutUI() {
    addSubviews(clientLabel, servicesLabel, commentIco, timeLabel)

    commentIco.translatesAutoresizingMaskIntoConstraints = false

    let padding: CGFloat = 8
    NSLayoutConstraint.activate([
      clientLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: padding),
      clientLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 14),
      clientLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -14),
      clientLabel.heightAnchor.constraint(equalToConstant: 20),
      
      servicesLabel.topAnchor.constraint(equalTo: clientLabel.bottomAnchor, constant: padding),
      servicesLabel.bottomAnchor.constraint(equalTo: timeLabel.topAnchor, constant: -padding),
      servicesLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 3*padding),
      servicesLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -padding),
            
      commentIco.widthAnchor.constraint(equalToConstant: 20),
      commentIco.heightAnchor.constraint(equalToConstant: 20),
      commentIco.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
      commentIco.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -12),

      timeLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
      timeLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 14),
      timeLabel.widthAnchor.constraint(equalToConstant: 100),
      timeLabel.heightAnchor.constraint(equalToConstant: 20)
    ])
  }
  
  // MARK: - Configuring methods
  
  private func configure() {
    customizeAppearance()
    layoutUI()
  }
  
  private func customizeAppearance() {
    layer.backgroundColor = Colors.eventColor.cgColor
    layer.cornerRadius = 18
  }
  
  private func addShadow() {
    layer.shadowColor = Colors.shadowColor.cgColor
    layer.shadowOpacity = 0.3
    layer.shadowOffset = .zero
    layer.shadowRadius = 1.2
    layer.shouldRasterize = true
    layer.rasterizationScale = UIScreen.main.scale
    layer.shadowPath = UIBezierPath(roundedRect: layer.bounds, cornerRadius: 18).cgPath
  }
}
