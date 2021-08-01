//
//  FinishLoadingState.swift
//  Mamilove
//
//  Created by 黃韋韜 on 2021/2/16.
//  Copyright © 2021 Shang-en Info. Co.,Ltd. All rights reserved.
//

import Foundation

final class FinishLoadingState: PageState {
  func updatePageController(_ pageController: PaginationControllerLogic, withNewDataSource newDataSource: PaginationDataSourece?) {
    if let loadMoreItemIndex = pageController.dataList.firstIndex(where: { $0 is LoadMoreCellItem }) {
      pageController.delete(rowIndexes: [loadMoreItemIndex])
    }
    
    if let property = pageController.shimmerCellProperty,
       pageController.dataList.contains(where: { $0 is ShimmerCellItem }) {
      pageController.delete(rowIndexes: Array(0...property.cellCount-1))
    }
    
    if let newDataSource = newDataSource {
      pageController.insert(items: newDataSource.pageItems)
      pageController.nextPage = newDataSource.nextPage
    }
    
    DispatchQueue.main.async {
      pageController.transitionToState(matching: AcceptInputState.identifier, withNewDataSource: newDataSource)
    }
  }
}
