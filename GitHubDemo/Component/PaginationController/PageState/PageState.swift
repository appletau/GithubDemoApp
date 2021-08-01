//
//  PageState.swift
//  Mamilove
//
//  Created by 黃韋韜 on 2021/2/14.
//  Copyright © 2021 Shang-en Info. Co.,Ltd. All rights reserved.
//

protocol PageState: class {
  func updatePageController( _ pageController: PaginationControllerLogic, withNewDataSource dataSource: PaginationDataSourece?)
}

extension PageState {
  static var identifier: String {
    return String(describing: self)
  }
}
