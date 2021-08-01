//
//  GithubSearchAPI.swift
//  GitHubDemo
//
//  Created by 黃韋韜 on 2021/7/31.
//

import Foundation
import Moya

enum GithubSearchAPI {
  
  enum ParamterKey {
    static let query = "q"
    static let page = "page"
    static let perPage = "per_page"
  }
  
  struct SearchUser: BaseGithubTargetType {
    let path: String = "/search/users"
    var task: Task {
      return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
    }
    
    private let parameters: [String: Any]
    
    init(queryString: String,
         page:Int,
         perPage: Int) {
      parameters = [ParamterKey.query: queryString,
                    ParamterKey.page: page,
                    ParamterKey.perPage: perPage]
    }
  }
  
}
