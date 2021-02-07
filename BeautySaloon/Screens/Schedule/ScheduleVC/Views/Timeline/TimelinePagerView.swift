//
//  TimelinePagerView.swift
//  BeautyShop
//
//  Created by Ермоленко Константин on 13.09.2020.
//  Copyright © 2020 Ермоленко Константин. All rights reserved.
//

import UIKit

protocol TimelinePagerViewDelegate: AnyObject {
  func scheduleNeedsUpdate()
}

class TimelinePagerView: UIView, UIPageViewControllerDataSource, UIPageViewControllerDelegate {

  // MARK: - Public properties
  
  let calendar: Calendar
  weak var state: DayViewState? {
    willSet {
      state?.unsubscribe(client: self)
    }
    didSet {
      state?.subscribe(client: self)
      if let viewControllers = pagingVC.viewControllers as? [TimelineContainerController] {
        for vc in viewControllers.enumerated() {
          vc.element.state = state
        }
      }
    }
  }
  var delegate: TimelinePagerViewDelegate?
  
  // MARK: - Private properties
  
  private var style = TimelineStyle()
  private let dateList: [Date] = DataManager.getDateList()
  private var pagingVC: UIPageViewController!
  
  // MARK: - Initialization
  
  init(calendar: Calendar) {
    self.calendar = calendar
    super.init(frame: .zero)
    configure()
  }
  
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Public methods
  
  func reloadData() {
    pagingVC.children.forEach({ (controller) in
      if let controller = controller as? TimelineContainerController {
        self.updateTimeline(controller.timeline)
      }
    })
  }
  
  // MARK: - Configuring methods
  
  private func configure() {
    translatesAutoresizingMaskIntoConstraints = false
    
    pagingVC = UIPageViewController(
      transitionStyle: .scroll,
      navigationOrientation: .horizontal,
      options: nil
    )
    pagingVC.setViewControllers(
      [createTimelineController(for: DataManager.currentDate())],
      direction: .forward,
      animated: false,
      completion: nil
    )
    pagingVC.dataSource = self
    pagingVC.delegate = self
    addSubview(pagingVC.view)
  }
  
  private func createTimelineController(for date: Date) -> TimelineContainerController {
    let controller = TimelineContainerController(date: date)
    controller.state = state
    controller.delegate = self
    updateStyleOfTimelineContainer(controller: controller)
    
    let timeline = controller.timeline
    timeline.calendar = calendar
    timeline.date = date.dateOnly(calendar: calendar)
    updateTimeline(timeline)
    
    return controller
  }
  
  private func updateStyleOfTimelineContainer(controller: TimelineContainerController) {
    let container = controller.container
    let timeline = controller.timeline
    timeline.updateStyle(style)
    container.backgroundColor = style.backgroundColor
  }
  
  private func updateTimeline(_ timeline: TimelineView) {
    let date = timeline.date.dateOnly(calendar: calendar)
    let events = DataSource.shared.getEvents(at: date)
    timeline.setLayoutAttributes(events.map(EventLayoutAttributes.init))
  }
  
  // MARK: - Layout
  
  override func layoutSubviews() {
    super.layoutSubviews()
    pagingVC.view.frame = bounds
  }
  
  // MARK: - UIPageViewControllerDataSource
  
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
    guard let containerController = viewController as? TimelineContainerController else { return nil }
    
    let currentDate = containerController.timeline.date
    
    if let index = dateList.firstIndex(of: currentDate) {
      if index > 0 {
        let previousDate = dateList[index - 1]
        return createTimelineController(for: previousDate)
      } else {
        if let previousDate = dateList.last {
          return createTimelineController(for: previousDate)
        }
      }
    }
    
    return nil
  }
  
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
    guard let containerController = viewController as? TimelineContainerController else { return nil }
    
    let currentDate = containerController.timeline.date
    
    if let index = dateList.firstIndex(of: currentDate) {
      if index < dateList.count - 1 {
        let nextDate = dateList[index + 1]
        return createTimelineController(for: nextDate)
      } else {
        if let nextDate = dateList.first {
          return createTimelineController(for: nextDate)
        }
      }
    }
    
    return nil
  }
  
  func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
    guard completed else { return }
    
    if let vc = pageViewController.viewControllers?.first as? TimelineContainerController {
      let selectedDate = vc.timeline.date
      state?.client(client: self, didMoveTo: selectedDate)
    }
  }
}

// MARK: - DayViewStateUpdating

extension TimelinePagerView: DayViewStateUpdating {
  
  func dateDidSelected(from oldDate: Date, to newDate: Date) {
    let oldDate = oldDate.dateOnly(calendar: calendar)
    let newDate = newDate.dateOnly(calendar: calendar)
    let newController = createTimelineController(for: newDate)
    
    func completionHandler(_ completion: Bool) {
      DispatchQueue.main.async {
        // Fix for the UIPageViewController issue: https://stackoverflow.com/questions/12939280/uipageviewcontroller-navigates-to-wrong-page-with-scroll-transition-style
        self.pagingVC.setViewControllers(
          [newController],
          direction: .reverse,
          animated: false,
          completion: nil
        )
      }
    }
    
    if newDate.isEarlier(than: oldDate) {
      pagingVC.setViewControllers(
        [newController],
        direction: .reverse,
        animated: true,
        completion: completionHandler(_:)
      )
    } else if newDate.isLater(than: oldDate) {
      pagingVC.setViewControllers(
        [newController],
        direction: .forward,
        animated: true,
        completion: completionHandler(_:)
      )
    }
  }

  func scheduleDidUpdated() {
    
  }
}

// MARK: - TimelineContainerControllerDelegate

extension TimelinePagerView: TimelineContainerControllerDelegate {
  func scheduleNeedsUpdate() {
    delegate?.scheduleNeedsUpdate()
  }
}
