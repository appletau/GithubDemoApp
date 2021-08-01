//
//  PaginationModel.swift
//  GitHubDemo
//
//  Created by 黃韋韜 on 2021/7/31.
//

import Foundation

struct PaginationModel<T:Decodable> {
  let nextPage: Int?
  let data: T
}
