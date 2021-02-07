//
//  PayrolltVC.swift
//  BeautyShop
//
//  Created by Ермоленко Константин on 13.07.2020.
//  Copyright © 2020 Ермоленко Константин. All rights reserved.
//

import UIKit

class PayrolltVC: UIViewController {
  
  var payrollData: [PayrollRecord]!
  var tableView: UITableView!
  
  // MARK: - Lifecycle methods
  
  override func viewDidLoad() {
    super.viewDidLoad()    
    view.backgroundColor = Colors.mainColor    
    configure()
    configureTableView()
    layoutUI()
    populatePayrollData()
  }
  
  // MARK: - Configuring methods
  
  private func configure() {
    view.backgroundColor = Colors.mainColor
    configureNavigationBar()
  }
  
  private func configureNavigationBar() {
    navigationController?.navigationBar.prefersLargeTitles = false
    navigationItem.title = "Начисления зарплаты"
  }

  private func configureTableView() {
    tableView = UITableView(frame: .zero, style: .grouped)
    tableView.rowHeight = 40
    tableView.allowsSelection = false
    tableView.dataSource = self
    tableView.register(OneLabelCell.self,
                       forCellReuseIdentifier: OneLabelCell.reuseID)
    tableView.register(TwoLabelCell.self,
                       forCellReuseIdentifier: TwoLabelCell.reuseID)
    tableView.backgroundColor = Colors.timelineBackground
    tableView.translatesAutoresizingMaskIntoConstraints = false

    view.addSubview(tableView)
  }

  private func layoutUI() {
    view.addSubview(tableView)
    
    NSLayoutConstraint.activate([
      tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
      tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
    ])
  }
  
  private func populatePayrollData() {
    payrollData = MockData().data
  }
}

// MARK: - Extensions

extension PayrolltVC: UITableViewDataSource {
  
  func numberOfSections(in tableView: UITableView) -> Int {
    3
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if section == 0  {
      return 2
    } else if section == 1 {
      return 4
    } else {
      return payrollData.count
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = TwoLabelCell()
    
    if indexPath.section == 0 {

      if indexPath.row == 0 {
        cell.keyLabel.text = "Месяц начисления"
        cell.valueLabel.text = "Февраль 2021"
      } else {
        cell.keyLabel.text = "Мастер"
        cell.valueLabel.text = "Администратор"
      }
      
    } else if indexPath.section == 1 {
      if indexPath.row == 0 {
        cell.keyLabel.text = "Заработная плата"
        cell.valueLabel.text = "25000"
      } else if indexPath.row == 1 {
        cell.keyLabel.text = "Итоговая цена"
        cell.valueLabel.text = "33000"
      } else if indexPath.row == 2 {
        cell.keyLabel.text = "Ритейл"
        cell.valueLabel.text = "19000"
      } else if indexPath.row == 3 {
        cell.keyLabel.text = "Количество"
        cell.valueLabel.text = "35"
      }      
      
    } else {
      let record = payrollData[indexPath.row]
      cell.keyLabel.text = record.key
      cell.valueLabel.text = record.value
    }
    return cell
  }
}

struct PayrollRecord {
  let key: String
  let value: String
}

struct MockData {
  let data = [
    PayrollRecord(key: "День", value: "Заработная плата"),
    PayrollRecord(key: "01.02.2021", value: "1200"),
    PayrollRecord(key: "02.02.2021", value: "1400"),
    PayrollRecord(key: "03.02.2021", value: "1200"),
    PayrollRecord(key: "04.02.2021", value: "900"),
    PayrollRecord(key: "05.02.2021", value: "1000"),
    PayrollRecord(key: "06.02.2021", value: "1100"),
    PayrollRecord(key: "07.02.2021", value: "800"),
    PayrollRecord(key: "08.02.2021", value: "1100"),
    PayrollRecord(key: "09.02.2021", value: "750"),
    PayrollRecord(key: "10.02.2021", value: "600"),
    PayrollRecord(key: "11.02.2021", value: "1300"),
    PayrollRecord(key: "12.02.2021", value: "1300"),
    PayrollRecord(key: "13.02.2021", value: "1300"),
    PayrollRecord(key: "14.02.2021", value: "1100"),
    PayrollRecord(key: "15.02.2021", value: "1200"),
    PayrollRecord(key: "16.02.2021", value: "1500"),
    PayrollRecord(key: "17.02.2021", value: "900"),
    PayrollRecord(key: "18.02.2021", value: "1000"),
    PayrollRecord(key: "19.02.2021", value: "1600"),
    PayrollRecord(key: "20.02.2021", value: "800"),
    PayrollRecord(key: "21.02.2021", value: "1000"),
    PayrollRecord(key: "22.02.2021", value: "1300"),
    PayrollRecord(key: "23.02.2021", value: "1300"),
    PayrollRecord(key: "24.02.2021", value: "700"),
    PayrollRecord(key: "25.02.2021", value: "800"),
    PayrollRecord(key: "26.02.2021", value: "1300"),
    PayrollRecord(key: "27.02.2021", value: "1000"),
    PayrollRecord(key: "28.02.2021", value: "1100"),
  ]
}
