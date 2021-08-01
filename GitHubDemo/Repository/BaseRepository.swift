//
//  BaseRepository.swift
//  GitHubDemo
//
//  Created by 黃韋韜 on 2021/7/31.
//

import Foundation
import RxSwift
import Moya

class BaseRepository {
  private let webservice: WebServiceLogic
  
  init(webservice: WebServiceLogic = WebServiceManager.shared) {
    self.webservice = webservice
  }
  
  final func sendRequest(target: TargetType) -> Single<Response> {
    return webservice.sendRequest(target: target)
  }
}
