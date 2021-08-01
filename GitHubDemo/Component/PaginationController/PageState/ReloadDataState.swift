//
//  ReloadDataState.swift
//  Mamilove
//
//  Created by 黃韋韜 on 2021/2/16.
//  Copyright © 2021 Shang-en Info. Co.,Ltd. All rights reserved.
//

import Foundation

final class ReloadDataState: PageState {
  func updatePageController(_ pageController: PaginationControllerLogic, withNewDataSource newDataSource: PaginationDataSourece? = nil) {
    var dataListCount: Int!
      DispatchQueue.main.sync {
        dataListCount = pageController.dataList.count
      }
    if dataListCount > 0 {
      let rowIndexes = Array(0...dataListCount-1)
      pageController.delete(rowIndexes: rowIndexes)
    }
    guard let property = pageController.shimmerCellProperty else { return }
    pageController.insert(items: Array(repeating: ShimmerCellItem(cellIdentifier: property.cellIdentifier), count: property.cellCount))
  }
}
