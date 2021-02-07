//
//  TimelineView.swift
//  BeautyShop
//
//  Created by Ермоленко Константин on 21.07.2020.
//  Copyright © 2020 Ермоленко Константин. All rights reserved.
//

import UIKit
import DateToolsSwift

protocol TimelineDelegate: class {
  func eventDidSelected(event: Event)
}

final class TimelineView: UIView {
  
  // MARK: - Public properties
  
  var date = Date() {
    didSet {
      setNeedsLayout()
    }
  }
  var calendar: Calendar = Calendar.autoupdatingCurrent
  var style = TimelineStyle()

  weak var delegate: TimelineDelegate?
  
  var width: CGFloat { return bounds.width - style.leftInset - 4}
  var height: CGFloat {
    return style.verticalInset * 2 + style.verticalDiff * CGFloat(timePeriod.length + 1)
  }
  private(set) var layoutAttributes = [EventLayoutAttributes]()
  
  // MARK: - Private properties
  
  private var eventViews = [EventView]()
  private let timePeriod: WorkingPeriod
  private var times: [String] {
    return TimeStringsFactory(calendar).make24hStrings(for: timePeriod)
  }
  private lazy var tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tap(_:)))
  
  // MARK: - Initialization
  
  init(timePeriod: WorkingPeriod) {
    self.timePeriod = timePeriod
    super.init(frame: .zero)
    configure()
  }
  
  required public init?(coder aDecoder: NSCoder) {
    self.timePeriod = WorkingPeriod(start: Date(), end: Date())
    super.init(coder: aDecoder)
    configure()
  }
  
  // MARK: - Public methods
  
  func updateStyle(_ newStyle: TimelineStyle) {
    style = newStyle
    backgroundColor = style.backgroundColor
    setNeedsDisplay()
  }
  
  func setLayoutAttributes(_ attributes: [EventLayoutAttributes]) {
    layoutAttributes.removeAll()
    for attribute in attributes {
      layoutAttributes.append(attribute)
    }
    recalculateEventLayout()
    prepareEventViews()
    setNeedsLayout()
  }
  
//  func redrawEvents(events: [Event]) {
//    
//    self.timeline.setLayoutAttributes(events.map(EventLayoutAttributes.init))
//  }
  // MARK: - Configuring methods
  
  private func configure() {
    frame.size.height = height
    
    contentScaleFactor = 1
    layer.contentsScale = 1
    contentMode = .redraw
    
    addGestureRecognizer(tapRecognizer)
  }
  
  // MARK: - Background Pattern
  
  override func draw(_ rect: CGRect) {
    super.draw(rect)
    
    let attributes = drawAttributes()
    
    for (i, time) in times.enumerated() {
      let iFloat = CGFloat(i)
      
      setupCurrentGraphicContext(iFloat)
      
      let fontSize = style.font.pointSize
      let timeRect = CGRect(x: 2,
                            y: iFloat * style.verticalDiff + style.verticalInset - 7,
                            width: style.leftInset - 20,
                            height: fontSize + 2)
      
      let timeString = NSString(string: time)
      timeString.draw(in: timeRect, withAttributes: attributes)
    }
  }
  
  private func drawAttributes() ->  [NSAttributedString.Key : Any] {
    let mutableParagraphStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
    mutableParagraphStyle.lineBreakMode = .byWordWrapping
    mutableParagraphStyle.alignment = .right
    let paragraphStyle = mutableParagraphStyle.copy() as! NSParagraphStyle
    
    let attributes = [
      NSAttributedString.Key.paragraphStyle: paragraphStyle,
      NSAttributedString.Key.foregroundColor: self.style.timeColor,
      NSAttributedString.Key.font: style.font
    ] as [NSAttributedString.Key : Any]
    
    return attributes
  }
  
  private func setupCurrentGraphicContext(_ iFloat: CGFloat)  {
    guard let context = UIGraphicsGetCurrentContext() else { return }
    
    context.interpolationQuality = .none
    context.saveGState()
    context.setStrokeColor(self.style.lineColor.cgColor)
    context.setLineWidth(onePixel)
    context.translateBy(x: 0, y: 0.5)
    let x: CGFloat = 53
    let y = style.verticalInset + iFloat * style.verticalDiff
    context.beginPath()
    context.move(to: CGPoint(x: x, y: y))
    context.addLine(to: CGPoint(x: (bounds).width, y: y))
    context.strokePath()
    context.restoreGState()
  }
  
  // MARK: - Layout
  
  override func layoutSubviews() {
    super.layoutSubviews()
    recalculateEventLayout()
    layoutEvents()
  }
  
  private func recalculateEventLayout() {
    let sortedEvents = self.layoutAttributes.sorted { (attr1, attr2) -> Bool in
      let start1 = attr1.event.startDate
      let start2 = attr2.event.startDate
      
      return start1.isEarlier(than: start2)
    }
    
    for (index, event) in sortedEvents.enumerated() {
      let yStart = dateToY(event.event.startDate)
      let yEnd = dateToY(event.event.endDate)
      let x = style.leftInset + 8 + CGFloat(index) / width
      event.frame = CGRect(x: x, y: yStart, width: width, height: yEnd - yStart)
    }
  }
  
  private func layoutEvents() {
    if eventViews.isEmpty { return }
    
    for (index, attributes) in layoutAttributes.enumerated() {
      let event = attributes.event
      let eventView = eventViews[index]
      eventView.frame = CGRect(x: attributes.frame.minX,
                               y: attributes.frame.minY,
                               width: attributes.frame.width - style.rightInset,
                               height: attributes.frame.height)
      eventView.update(with: event)
    }
  }
  
  private func prepareEventViews() {
    eventViews.forEach { $0.removeFromSuperview() }
    eventViews.removeAll()
    
    for _ in layoutAttributes {
      let newView = EventView()
      eventViews.append(newView)
    }
    
    eventViews.forEach { addSubview($0) }
  }
  
  // MARK: - Gestures
  
  @objc private func tap(_ sender: UITapGestureRecognizer) {
    let pressedLocation = sender.location(in: self)
    if let eventView = findEventView(at: pressedLocation) {
      if let ev = DataSource.shared.getEvent(by: eventView.id, at: date) {
        delegate?.eventDidSelected(event: ev)
      }
    }
  }
  
  private func findEventView(at point: CGPoint) -> EventView? {
    for eventView in eventViews {
      let frame = eventView.frame
      if frame.contains(point) {
        return eventView
      }
    }
    return nil
  }
  
  // MARK: - Private methods

  private func dateToY(_ date: Date) -> CGFloat {
    let hour = component(component: .hour, from: date)
    let minute = component(component: .minute, from: date)
    let hourY = CGFloat(hour - timePeriod.hours.first!) * style.verticalDiff + style.verticalInset
    let minuteY = CGFloat(minute) * style.verticalDiff / 60
    
    return hourY + minuteY
  }
  
  private func yToDate(_ y: CGFloat) -> Date {
    let timeValue = y - style.verticalInset
    var hour = Int(timeValue / style.verticalDiff)
    let fullHourPoints = CGFloat(hour) * style.verticalDiff
    let minuteDiff = timeValue - fullHourPoints
    let minute = Int(minuteDiff / style.verticalDiff * 60)
    var dayOffset = 0
    if hour > 23 {
      dayOffset += 1
      hour -= 24
    } else if hour < 0 {
      dayOffset -= 1
      hour += 24
    }
    let offsetDate = calendar.date(byAdding: DateComponents(day: dayOffset),
                                   to: date)!
    let newDate = calendar.date(bySettingHour: hour,
                                minute: minute.clamped(to: 0...59),
                                second: 0,
                                of: offsetDate)
    return newDate!
  }
  
  private var onePixel: CGFloat {
    return 1 / UIScreen.main.scale
  }
  
  private func component(component: Calendar.Component, from date: Date) -> Int {
    return calendar.component(component, from: date)
  }
  
  private func getDateInterval(date: Date) -> TimePeriod {
    let earliestEventMintues = component(component: .minute, from: date)
    let splitMinuteInterval  = style.splitMinuteInterval
    let minute               = component(component: .minute, from: date)
    let minuteRange          = (minute / splitMinuteInterval) * splitMinuteInterval
    let beginningRange       = calendar.date(byAdding: .minute, value: -(earliestEventMintues - minuteRange), to: date)!
    let endRange             = calendar.date(byAdding: .minute, value: splitMinuteInterval, to: beginningRange)
    
    return TimePeriod.init(beginning: beginningRange, end: endRange)
  }
}
