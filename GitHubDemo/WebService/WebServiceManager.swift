//
//  WebServiceManager.swift
//  GitHubDemo
//
//  Created by 黃韋韜 on 2021/7/31.
//

import Foundation
import Moya
import RxSwift

protocol WebServiceLogic: AnyObject {
  func sendRequest(target: TargetType) -> Single<Response>
}

final class WebServiceManager: WebServiceLogic {
  static let shared: WebServiceLogic = WebServiceManager()
  
  private lazy var provider: MoyaProvider<MultiTarget> = {
    return configureProvider()
  }()
  
  
  func sendRequest(target: TargetType) -> Single<Response> {
    let multiTargetType: MultiTarget = MultiTarget(target)
    return self.provider.rx.request(multiTargetType)
  }
  
  private func JsonResponseDataFormatter(_ data: Data) -> String {
    do {
      let dataAsJSON = try JSONSerialization.jsonObject(with: data)
      let prettyData = try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
      return String(data: prettyData, encoding: .utf8) ?? String(data: data, encoding: .utf8) ?? ""
    } catch {
      return String(data: data, encoding: .utf8) ?? ""
    }
  }
  
  private func configureProvider() -> MoyaProvider<MultiTarget> {
    let pluginConfiguration: NetworkLoggerPlugin.Configuration = .init(formatter: .init(responseData: JsonResponseDataFormatter),
                                                                       logOptions: .verbose)
    let logPlugin: NetworkLoggerPlugin = .init(configuration: pluginConfiguration)
    
    let sessionConfiguration = URLSessionConfiguration.default
    sessionConfiguration.headers = .default
    sessionConfiguration.timeoutIntervalForRequest = 60
    let session = Session(configuration: sessionConfiguration,
                          startRequestsImmediately: false)
    return .init(callbackQueue: .global(),
                 session: session,
                 plugins: [logPlugin])
  }
}
