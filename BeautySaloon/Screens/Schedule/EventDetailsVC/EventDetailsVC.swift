//
//  EventDetailsVC.swift
//  BeautyShop
//
//  Created by Ермоленко Константин on 21.10.2020.
//  Copyright © 2020 Ермоленко Константин. All rights reserved.
//

import UIKit

class EventDetailsVC: UIViewController {
  
  // MARK: - Public properties
  
  let event: Event
  var eventData: EventData!
  var tableView: UITableView!

  // MARK: - Initialization
  
  init(of event: Event) {
    self.event = event
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Lifecycle methods
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configure()
    configureTableView()
    populateData()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.setNavigationBarHidden(false, animated: true)
  }
  
  // MARK: - Configuring methods
  
  private func configure() {
    view.backgroundColor = Colors.mainColor
    configureNavigationBar()
  }
  
  private func configureNavigationBar() {
    navigationController?.navigationBar.prefersLargeTitles = false
    navigationItem.title = event.title
  }
  
  private func configureTableView() {
    let tableView = UITableView(frame: view.bounds, style: .grouped)
    tableView.rowHeight = 40
    tableView.allowsSelection = false
    tableView.dataSource = self
    tableView.register(OneLabelCell.self,
                       forCellReuseIdentifier: OneLabelCell.reuseID)
    tableView.register(TwoLabelCell.self,
                       forCellReuseIdentifier: TwoLabelCell.reuseID)
    tableView.backgroundColor = Colors.timelineBackground

    view.addSubview(tableView)
  }
 
  // MARK: - Private methods
  
  private func populateData() {
    var totalCost = 0.0
    var services = [EventInfoRecord]()
    
    for serviceItem in event.services {
      services.append(EventInfoRecord(key: "Работа",
                                      value: serviceItem.service))
      services.append(EventInfoRecord(key: "Количество",
                                      value: "\(serviceItem.quantity)"))
      services.append(EventInfoRecord(key: "Стоимость",
                                      value: String(format: "%.2f", serviceItem.cost)))
      services.append(EventInfoRecord(key: "Период", value: "11:00 - 12:15"))
      totalCost += serviceItem.cost
    }
    
    eventData = [
      0: [EventInfoRecord(key: "Дата начала",
                          value: event.creationDate.convertToDayMonthFormat()),
          EventInfoRecord(key: "Организация",
                          value: event.company)],
      1: [EventInfoRecord(key: "Клиент",
                          value: event.client),
          EventInfoRecord(key: "Время начала",
                          value: event.startDate.shortTimeFormat()),
          EventInfoRecord(key: "Время окончания",
                          value: event.endDate.shortTimeFormat())],
      2: services,
      3: [EventInfoRecord(key: "Сумма",
                          value: String(format: "%.2f", totalCost))],
      4: [EventInfoRecord(key: "Комментарий",
                          value: event.comment)],
    ]
  }
  
  private func getCellInfo(eventData: EventData, indexPath: IndexPath) -> EventInfoRecord? {
    guard let sectionData = eventData[indexPath.section] else { return nil }
    
    return sectionData[indexPath.row]
  }

  @objc private func dismissVC() {
    dismiss(animated: true)
  }
}

// MARK: - Extensions

extension EventDetailsVC: UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return eventData.count
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let dataSection = eventData[section]
    return dataSection?.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    if section == 2 {      
      return "Работы"
    } else if section == 4 {
      return "Комментарий"
    }
    return nil
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let info = getCellInfo(eventData: eventData, indexPath: indexPath) else {
      return UITableViewCell()
    }
    
    if oneLabelCellNeeded(info: info) {
      let cell = tableView.dequeueReusableCell(withIdentifier: OneLabelCell.reuseID,
                                               for: indexPath) as! OneLabelCell
      cell.set(withInfo: info)
      
      return cell
      
    } else {
      let cell = tableView.dequeueReusableCell(withIdentifier: TwoLabelCell.reuseID,
                                               for: indexPath) as! TwoLabelCell
      cell.set(withInfo: info)
      return cell
    }
  }
  
  func oneLabelCellNeeded(info: EventInfoRecord) -> Bool {
    return info.key == "Мастер"
        || info.key == "Работа"
        || info.key == "Комментарий"
  }
}
