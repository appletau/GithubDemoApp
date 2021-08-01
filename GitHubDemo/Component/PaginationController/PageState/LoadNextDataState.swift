//
//  LoadNextDataState.swift
//  Mamilove
//
//  Created by 黃韋韜 on 2021/2/16.
//  Copyright © 2021 Shang-en Info. Co.,Ltd. All rights reserved.
//

import Foundation

final class LoadNextDataState: PageState {
  func updatePageController(_ pageController: PaginationControllerLogic, withNewDataSource newDataSource: PaginationDataSourece? = nil) {
    guard let identifier = pageController.loadMoreCellIdentifier else { return }
    pageController.insert(items: [LoadMoreCellItem(cellIdentifier: identifier)])
  }
}
