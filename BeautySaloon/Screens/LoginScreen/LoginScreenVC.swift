//
//  LoginScreenVC.swift
//  BeautyShop
//
//  Created by Ермоленко Константин on 26.11.2020.
//  Copyright © 2020 Ермоленко Константин. All rights reserved.
//

import UIKit

class LoginScreenVC: UIViewController {
  
  // MARK: - Public properties
  
  var logoImage: UIImageView!
  let usernameField = BSTextField(placeholder: "Имя пользователя")
  let passwordField = BSTextField(placeholder: "Пароль")
  let loginButton = UIButton()
  let activityIndicator = UIActivityIndicatorView()
  let errorMessageLabel = UILabel()
  
  // MARK: - Lifecycle methods
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = Colors.mainColor
    logoImage = UIImageView(image: UIImage(systemName: "swift"))
    logoImage.tintColor = .label

    layoutUI()
    configure()
    createTapGestureRecognizer()    

    addObserversAuthenticationSucceeded()
  }
  
  // MARK: - Configuring methods
  
  private func configure() {
    logoImage.contentMode = .scaleAspectFit
    
    passwordField.textContentType = .password
    passwordField.isSecureTextEntry = true
    passwordField.addTarget(self, action: #selector(textFieldDidChange),
                            for: .editingChanged)
    
    loginButton.isEnabled = false
    loginButton.backgroundColor = .secondaryLabel
    
    loginButton.layer.cornerRadius = 6
    loginButton.setTitle("Войти", for: .normal)
    loginButton.addTarget(self, action: #selector(loginButtonTapped),
                          for: .touchUpInside)
    
    errorMessageLabel.textColor = .systemRed
    errorMessageLabel.textAlignment = .center
    errorMessageLabel.isHidden = true
  }
  
  private func layoutUI() {
    view.addSubviews(usernameField, passwordField, loginButton, logoImage, errorMessageLabel)
    
    for subview in view.subviews {
      subview.translatesAutoresizingMaskIntoConstraints = false
    }
    
    let vPadding: CGFloat = 13
    let hPadding: CGFloat = 40
    let height: CGFloat = 45
    
    NSLayoutConstraint.activate([
      logoImage.bottomAnchor.constraint(equalTo: usernameField.topAnchor, constant: -vPadding),
      logoImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      logoImage.widthAnchor.constraint(equalToConstant: 157),
      logoImage.heightAnchor.constraint(equalToConstant: 155),
      
      usernameField.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -65),
      usernameField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: hPadding),
      usernameField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -hPadding),
      usernameField.heightAnchor.constraint(equalToConstant: height),
      
      passwordField.topAnchor.constraint(equalTo: usernameField.bottomAnchor, constant: vPadding),
      passwordField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: hPadding),
      passwordField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -hPadding),
      passwordField.heightAnchor.constraint(equalToConstant: height),
      
      loginButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: vPadding),
      loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: hPadding),
      loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -hPadding),
      loginButton.heightAnchor.constraint(equalToConstant: height),
      
      errorMessageLabel.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: vPadding),
      errorMessageLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: hPadding),
      errorMessageLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -hPadding),
      errorMessageLabel.heightAnchor.constraint(equalToConstant: height)
    ])
    
    addActivityIndicator()
  }
  
  private func addActivityIndicator() {
    view.addSubview(activityIndicator)
    activityIndicator.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      activityIndicator.centerXAnchor.constraint(equalTo: loginButton.centerXAnchor),
      activityIndicator.centerYAnchor.constraint(equalTo: loginButton.centerYAnchor),
    ])
  }
  
  private func createTapGestureRecognizer() {
    let tap = UITapGestureRecognizer(target: view,
                                     action: #selector(UIView.endEditing))
    view.addGestureRecognizer(tap)
  }
  
  // MARK: - Text fields
  
  @objc private func textFieldDidChange() {
    if usernameAndPasswordAreFilled() {
      loginButton.isEnabled = true
      loginButton.backgroundColor = Colors.accentColor
    } else {
      loginButton.isEnabled = false
      loginButton.backgroundColor = .secondaryLabel
    }
  }
  
  // MARK: - Actions
  
  @objc private func loginButtonTapped() {
    guard usernameAndPasswordAreFilled() else { return }
    passAuthentication()
  }

  private func usernameAndPasswordAreFilled() -> Bool {
    guard let username = usernameField.text, username.count > 0 else {
      return false
    }
    guard let password = passwordField.text, password.count > 0 else {
      return false
    }
    
    return true
  }
  
  // MARK: - Credentials
  
  private func credentialsFromFields() -> Credentials {
    let credentials = Credentials(
      username: usernameField.text ?? "",
      password: passwordField.text ?? ""
    )
    return credentials
  }
    
  // MARK: - Authentication
  
  private func passAuthentication() {
    view.endEditing(true)
    
    showActivityIndicator()
    let credentials = credentialsFromFields()
    NetworkManager.shared.passAuthentication(credentials: credentials) { result in
      switch result {
      case .failure(let error):
        self.handleLoginError(message: error.rawValue)
      case .success(let authData):
        CredentialManager.shared.saveUserCredentials(credentials: credentials)
        let userInfo = UserInfo(id: authData.id,
                                role: authData.role,
                                username: authData.username)
        PersistenceManager.saveUserInfo(userInfo: userInfo)
        DataSource.shared.getSubordinates()
      }
    }
  }
  
  private func handleLoginError(message: String) {
    DispatchQueue.main.async {
      self.hideActivityIndicator()
      self.showErrorLabel(with: message)
      self.highlightTextFields()
    }
  }
  
  // MARK: - Activity Indicator

  private func showActivityIndicator() {
    loginButton.setTitle("", for: .normal)
    activityIndicator.startAnimating()
  }
   
  private func hideActivityIndicator() {
    DispatchQueue.main.async {
      self.loginButton.setTitle("Войти", for: .normal)
      self.activityIndicator.stopAnimating()
    }
  }
    
  // MARK: - Error alerts

  private func showErrorLabel(with massage: String) {
    self.errorMessageLabel.text = massage
    self.errorMessageLabel.isHidden = false
  }
  
  private func hideErrorLabel() {
    errorMessageLabel.isHidden = true
  }
  
  private func highlightTextFields() {
    let borderColor = self.usernameField.layer.borderColor
    
    UIView.animate(withDuration: 0.5, delay: 0, options: [.curveLinear], animations: {
      self.usernameField.layer.borderColor = UIColor.systemRed.cgColor
      self.passwordField.layer.borderColor = UIColor.systemRed.cgColor
    }) { _ in
      DispatchQueue.main.asyncAfter(deadline: .now()+2.5) {
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveLinear], animations: {
          self.usernameField.layer.borderColor = borderColor
          self.passwordField.layer.borderColor = borderColor
        })
      }
    }
  }

  private func addObserversAuthenticationSucceeded() {
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(handleAuthenticationSucceeded(notification:)),
      name: DataFetchingResults.authenticationSucceeded,
      object: nil
    )
  }
  
  @objc private func handleAuthenticationSucceeded(notification: Notification) {
    guard notification.name == DataFetchingResults.authenticationSucceeded else { return }
    DataSource.shared.fetchSchedule()
  }
}
