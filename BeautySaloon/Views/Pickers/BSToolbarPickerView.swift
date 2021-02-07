//
//  ToolbarPickerView.swift
//  BeautyShop
//
//  Created by Ермоленко Константин on 27.01.2021.
//  Copyright © 2021 Ермоленко Константин. All rights reserved.
//

import UIKit

protocol BSToolbarPickerViewDelegate: class {
  func didTapDone()
  func didTapCancel()
}

class BSToolbarPickerView: UIView {
  
  // MARK: - Public properties
  
  let pickerView: UIPickerView!
  let toolbar: UIToolbar!
  var selectedRow: Int {
    pickerView.selectedRow(inComponent: 0)
  }
  
  weak var toolbarDelegate: BSToolbarPickerViewDelegate?

  // MARK: - Initialization
  
  override init(frame: CGRect) {
    pickerView = UIPickerView()
    toolbar = UIToolbar()
    super.init(frame: frame)
    
    configure()
  }
  
  convenience init(delegate: BSToolbarPickerViewDelegate) {
    self.init(frame: .zero)
    toolbarDelegate = delegate
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Public methods
  
  func reload() {
    pickerView.reloadAllComponents()
  }

  // MARK: - Configuring methods

  private func configure() {
    setupToolbar()
    setupAppearance()    
    layoutElements()
  }
  
  private func setupToolbar() {
    let doneButton = UIBarButtonItem(title: "Выбрать",
                                     style: .done,
                                     target: self,
                                     action: #selector(self.doneTapped))
    let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                 target: nil,
                                 action: nil)
    let cancelButton = UIBarButtonItem(title: "Отмена",
                                       style: .plain,
                                       target: self,
                                       action: #selector(self.cancelTapped))
    toolbar.barStyle = .default
    toolbar.items = [cancelButton, spacer, doneButton]
  }
  
  private func setupAppearance() {
    toolbar.backgroundColor = Colors.mainColor
    toolbar.tintColor = Colors.accentColor
    pickerView.backgroundColor = Colors.timelineBackground
  }
  
  // MARK: - Layout
  
  private func layoutElements() {
    addSubviews(toolbar, pickerView)
    
    translatesAutoresizingMaskIntoConstraints = false
    toolbar.translatesAutoresizingMaskIntoConstraints = false
    pickerView.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      toolbar.topAnchor.constraint(equalTo: topAnchor),
      toolbar.heightAnchor.constraint(equalToConstant: 40),
      toolbar.leadingAnchor.constraint(equalTo: leadingAnchor),
      toolbar.trailingAnchor.constraint(equalTo: trailingAnchor),
      
      pickerView.topAnchor.constraint(equalTo: toolbar.bottomAnchor),
      pickerView.bottomAnchor.constraint(equalTo: bottomAnchor),
      pickerView.leadingAnchor.constraint(equalTo: leadingAnchor),
      pickerView.trailingAnchor.constraint(equalTo: trailingAnchor),
    ])
  }

  // MARK: - Private methods
    
  @objc private func doneTapped() {
    self.toolbarDelegate?.didTapDone()
  }
  
  @objc private func cancelTapped() {
    self.toolbarDelegate?.didTapCancel()
  }
}
