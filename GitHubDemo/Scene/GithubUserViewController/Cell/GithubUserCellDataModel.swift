//
//  GithubUserCellDataModel.swift
//  GitHubDemo
//
//  Created by 黃韋韜 on 2021/7/31.
//

import Foundation

struct GithubUserCellDataModel {
  let name: String
  let avatarUrl: URL?
}

extension GithubUserCellDataModel: PaginationControllerItem {
  var cellIdentifier: String {
    return GithubUserCollectionCell.describing
  }
}
