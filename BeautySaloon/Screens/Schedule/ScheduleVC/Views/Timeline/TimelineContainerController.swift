//
//  TimelineContainerController.swift
//  BeautyShop
//
//  Created by Ермоленко Константин on 21.07.2020.
//  Copyright © 2020 Ермоленко Константин. All rights reserved.
//

import UIKit

protocol TimelineContainerControllerDelegate: AnyObject {
  func scheduleNeedsUpdate()
}

class TimelineContainerController: UIViewController {
  
  // MARK: - Properties
  
  let date: Date
  lazy var timeline = TimelineView(timePeriod: DateManager.shared.workingPeriod)
  lazy var container: TimelineContainer = {
    let timelineContainer = TimelineContainer(timeline, date: date)
    timeline.delegate = self
    timelineContainer.addSubview(timeline)
    timelineContainer.containerDelegate = self
    return timelineContainer
  }()
  weak var state: DayViewState? {
    willSet {
      state?.unsubscribe(client: self)
    }
    didSet {
      state?.subscribe(client: self)
      container.state = state
    }
  }
 var delegate: TimelineContainerControllerDelegate?
  
  // MARK: - Initialization

  init(date: Date) {
    self.date = date
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Lyfecycle methods
  
  override func loadView() {
    view = container
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()    
    container.contentSize = timeline.frame.size
  }
}

// MARK: - TimelineDelegate

extension TimelineContainerController: TimelineDelegate {
  func eventDidSelected(event: Event) {
    guard event.type == "work" else { return }

    let mainTB = UIApplication.shared.windows.first!.rootViewController as! MainTabBar
    let nav = mainTB.viewControllers?.first as? UINavigationController
      
    nav?.pushViewController(EventDetailsVC(of: event), animated: true)
  }
}

// MARK: - DayViewStateUpdating

extension TimelineContainerController: DayViewStateUpdating {
  func dateDidSelected(from oldDate: Date, to newDate: Date) {}

  func scheduleDidUpdated() {}
}

// MARK: - TimelineContainerDelegate

extension TimelineContainerController:  TimelineContainerDelegate {
  func scheduleNeedsUpdate() {
    delegate?.scheduleNeedsUpdate()
  }
}
