//
//  TimelineContainer.swift
//  BeautyShop
//
//  Created by Ермоленко Константин on 21.07.2020.
//  Copyright © 2020 Ермоленко Константин. All rights reserved.
//

import UIKit

protocol TimelineContainerDelegate: AnyObject {
  func scheduleNeedsUpdate()
}

class TimelineContainer: UIScrollView {
  
  // MARK: - Properties
  
  let date: Date
  let timeline: TimelineView
  weak var state: DayViewState? {
    willSet {
      state?.unsubscribe(client: self)
    }
    didSet {
      state?.subscribe(client: self)
    }
  }
  var containerDelegate: TimelineContainerDelegate?
  
  // MARK: - Initialization
  
  init(_ timeline: TimelineView, date: Date) {
    self.timeline = timeline
    self.date = date
    super.init(frame: .zero)
    configure()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Lifecycle methods
  
    override func layoutSubviews() {
      super.layoutSubviews()
      timeline.frame = CGRect(x: 0, y: 0,
                              width: bounds.width,
                              height: timeline.height)
    }
  
  // MARK: - Configuring methods
  
  private func configure() {
    configureRefreshControl()
  }
  
  private func configureRefreshControl() {
    refreshControl = UIRefreshControl()
    refreshControl?.addTarget(self,
                              action: #selector(handleRefreshControl),
                              for: .valueChanged)
  }
  
  // MARK: - Private methods
  
  @objc private func handleRefreshControl() {
    addObservers()
    containerDelegate?.scheduleNeedsUpdate()
    
    DispatchQueue.main.async {
      self.refreshControl?.beginRefreshing()
    }
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
// MARK: - DayViewStateUpdating

extension TimelineContainer: DayViewStateUpdating {
  func dateDidSelected(from oldDate: Date, to newDate: Date) {}

  func scheduleDidUpdated() {
    DispatchQueue.main.async {
      self.refreshControl?.endRefreshing()
      let events = DataSource.shared.getEvents(at: self.date)
      self.timeline.setLayoutAttributes(events.map(EventLayoutAttributes.init))
    }
  }
}
