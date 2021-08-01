//
//  BaseTargetType.swift
//  GitHubDemo
//
//  Created by 黃韋韜 on 2021/7/31.
//

import Moya

protocol BaseGithubTargetType: TargetType {}

extension BaseGithubTargetType {
  var baseURL: URL { return URL(string: "https://api.github.com")! }
  var method: Moya.Method { return .get }
  var headers: [String : String]? { return nil }
  var task: Task { return .requestPlain }
  var sampleData: Data { return Data() }
}
