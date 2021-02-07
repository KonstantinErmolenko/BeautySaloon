//
//  ScheduleVC.swift
//  BeautyShop
//
//  Created by Ермоленко Константин on 13.07.2020.
//  Copyright © 2020 Ермоленко Константин. All rights reserved.
//

import UIKit
//import DateToolsSwift

class ScheduleVC: UIViewController {

  // MARK: - Public properties
  
  var calendar = Calendar.autoupdatingCurrent
  var state: DayViewState? {
    willSet {
      state?.unsubscribe(client: self)
    }
    didSet {
      state?.subscribe(client: self)
      dayHeaderView.state = state
      timelinePagerView.state = state
    }
  }
  var userInfo: UserInfo!
  var selectedUserId: String!

  let dayHeaderView: DayHeaderView!
  let timelinePagerView: TimelinePagerView!
  var masterPickerView: BSToolbarPickerView!
  var masters = [Subordinate]()
  var loadingViewContainer: UIView!
  var isLoading = false
  
  // MARK: - Initialization

  init() {
    dayHeaderView = DayHeaderView(calendar: calendar)
    timelinePagerView = TimelinePagerView(calendar: calendar)
    super.init(nibName: nil, bundle: nil)
    timelinePagerView.delegate = self
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Lifecycle methods
  
  override func viewDidLoad() {
    super.viewDidLoad()
    state = DayViewState()
    populateUserInfo()
    configure()
    layoutUI()
    updateInfo(for: DataManager.currentDate())
    customizeScreenDependingOnRole()
    reloadData()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.setNavigationBarHidden(true, animated: true)
  }

  // MARK: - Configuring methods
  
  private func populateUserInfo() {
    userInfo = DataSource.shared.getUserInfo()
    selectedUserId = userInfo.id
    dayHeaderView.setMaster(name: userInfo.username)
  }
  
  private func configure() {
    dayHeaderView.delegate = self

    view.backgroundColor = Colors.mainColor
    populateMasters()
  }
  
  private func layoutUI() {
    view.addSubviews(
      dayHeaderView,
      timelinePagerView
    )
    
    let verticalPadding: CGFloat = 8
    NSLayoutConstraint.activate([
      dayHeaderView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                         constant: verticalPadding),
      dayHeaderView.heightAnchor.constraint(equalToConstant: 150),
      dayHeaderView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      dayHeaderView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      
      timelinePagerView.topAnchor.constraint(equalTo: dayHeaderView.bottomAnchor,
                                             constant: verticalPadding),
      timelinePagerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
      timelinePagerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      timelinePagerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
    ])
  }

  // MARK: - Private methods

  private func customizeScreenDependingOnRole() {
    if userInfo.role == .administrator {
      setupPicker()
    }
  }
  
  private func updateHeader(with info: DayInfo) {
    dayHeaderView.update(withInfo: info)
  }
  
  private func reloadData() {
    timelinePagerView.reloadData()
  }
  
  // MARK: - Master Picker
  
  private func setupPicker() {
    masterPickerView = BSToolbarPickerView(delegate: self)
    masterPickerView.pickerView.delegate = self
    masterPickerView.pickerView.dataSource = self
    masterPickerView.isHidden = true
    view.addSubview(masterPickerView)
    
    NSLayoutConstraint.activate([
      masterPickerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
      masterPickerView.heightAnchor.constraint(equalToConstant: 180),
      masterPickerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      masterPickerView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
    ])
  }
  
  private func showMasterPicker() {
    guard masterPickerView.isHidden else { return }
    masterPickerView.fadeIn(duration: 0.15)
  }

  private func hideMasterPicker() {
    guard !masterPickerView.isHidden else { return }
    masterPickerView.fadeOut(duration: 0.15)
  }

  private func populateMasters() {
    masters.removeAll()
    
    if let subordinates = PersistenceManager.retrieveSubordinates() {
      for subordinate in subordinates {
        if subordinate.id != selectedUserId {
          masters.append(subordinate)
        }
      }
    }
    if selectedUserId != userInfo.id {
      masters.append(Subordinate(id: userInfo.id, name: userInfo.username))
    }
  }

}

// MARK: - DayViewStateUpdating

extension ScheduleVC: DayViewStateUpdating {
  
  func dateDidSelected(from oldDate: Date, to newDate: Date) {
    updateInfo(for: newDate)
  }
    
  func scheduleDidUpdated() {

    DispatchQueue.main.async {
      self.populateMasters()
      self.masterPickerView.reload()

      self.timelinePagerView.reloadData()
      if let state = self.state {
        self.updateInfo(for: state.currentDate)
      }
      
      self.dismissLoadingView()
    }
  }

  func updateInfo(for date: Date) {
    let info = DataSource.shared.getSummaryInfo(at: date)
    updateHeader(with: info)
  }
  
  private func addObservers() {
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(fetchingDataCompleted(notification:)),
      name: DataFetchingResults.completedSuccessfully,
      object: nil
    )
    
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(fetchingDataCompleted(notification:)),
      name: DataFetchingResults.completedWithError,
      object: nil
    )
  }
  
  private func removeObservers() {
    NotificationCenter.default.removeObserver(self,
                                              name: DataFetchingResults.completedSuccessfully,
                                              object: nil)
    NotificationCenter.default.removeObserver(self,
                                              name: DataFetchingResults.completedWithError,
                                              object: nil)
  }
  
  @objc private func fetchingDataCompleted(notification: Notification) {
    if notification.name == DataFetchingResults.completedSuccessfully
    || notification.name == DataFetchingResults.completedWithError {
      removeObservers()
      scheduleDidUpdated()
    }
  }
}

// MARK: - PickerViewDelegate

extension ScheduleVC: BSToolbarPickerViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
 
  func didTapDone() {
    let masterRecord = masters[masterPickerView.selectedRow]
    selectedUserId = masterRecord.id
    
    hideMasterPicker()
    showLoadingView()
    
    dayHeaderView.setMaster(name: masterRecord.name)
    
    addObservers()
    DataSource.shared.fetchSchedule(forUserId: masterRecord.id)
  }
  
  func didTapCancel() {
    hideMasterPicker()
  }

  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return masters.count
  }
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    let masterRecord = masters[row]
    return masterRecord.name
  }
}

// MARK: - DayHeaderViewDelegate

extension ScheduleVC: DayHeaderViewDelegate {
  
  func masterLabelDidTap() {
    if !isLoading {
      showMasterPicker()
    }
  }
}

// MARK: - Activity Indicator

extension ScheduleVC {
  
  func showLoadingView() {
    isLoading = true
    
    loadingViewContainer = UIView()
    loadingViewContainer.backgroundColor = Colors.mainColor
    loadingViewContainer.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(loadingViewContainer)
    
    NSLayoutConstraint.activate([
      loadingViewContainer.topAnchor.constraint(equalTo: dayHeaderView.bottomAnchor),
      loadingViewContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
      loadingViewContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      loadingViewContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
    ])
    
    loadingViewContainer.alpha = 0
    UIView.animate(withDuration: 0.25) { self.loadingViewContainer.alpha = 0.8 }
    
    let activityIndicator = UIActivityIndicatorView()
    activityIndicator.style = .large
    activityIndicator.color = Colors.accentColor
    loadingViewContainer.addSubview(activityIndicator)
    
    activityIndicator.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      activityIndicator.centerXAnchor.constraint(equalTo: loadingViewContainer.centerXAnchor),
      activityIndicator.centerYAnchor.constraint(equalTo: loadingViewContainer.centerYAnchor)
    ])
    
    activityIndicator.startAnimating()
  }
  
  func dismissLoadingView() {
    DispatchQueue.main.async {
      self.isLoading = false
      
      UIView.animate(withDuration: 0.25) {
        self.loadingViewContainer.alpha = 0
      }
      self.loadingViewContainer.removeFromSuperview()
      self.loadingViewContainer = nil
    }
  }
}

// MARK: - TimelinePagerViewDelegate

extension ScheduleVC: TimelinePagerViewDelegate {
  func scheduleNeedsUpdate() {
    DataSource.shared.fetchSchedule(forUserId: selectedUserId)
  }
}
