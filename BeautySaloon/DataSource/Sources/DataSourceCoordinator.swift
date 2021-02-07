//
//  DataSourceCoordinator.swift
//  BeautyShop
//
//  Created by Ермоленко Константин on 04.12.2020.
//  Copyright © 2020 Ермоленко Константин. All rights reserved.
//

import Foundation

struct DataSourceCoordinator {

  // MARK: - Public methods
 
  static func getDataSource() -> ScheduleDataSource {
    if CommandLine.arguments.contains("-mockApi") {
      return MockDataSource.shared
    } else {
      return DataSource.shared
    }
  }
}
