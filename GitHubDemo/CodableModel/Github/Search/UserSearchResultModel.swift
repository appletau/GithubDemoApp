//
//  UserSearchResultModel.swift
//  GitHubDemo
//
//  Created by 黃韋韜 on 2021/7/31.
//

import Foundation

struct UserSearchResultModel: Codable {
  struct UserData: Codable {
    let id: Int
    let login: String
    let avatarUrl: URL?
  }
  
  let items: [UserData]
}
