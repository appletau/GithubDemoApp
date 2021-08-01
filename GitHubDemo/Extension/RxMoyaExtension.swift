//
//  RxMoyaExtension.swift
//  GitHubDemo
//
//  Created by 黃韋韜 on 2021/7/31.
//

import Foundation
import RxSwift
import Moya

extension PrimitiveSequence where Trait == SingleTrait, Element == Response {
  
  func mapToPaginationModel<D: Decodable>(_ type: D.Type,
                                          atKeyPath keyPath: String? = nil,
                                          using decoder: JSONDecoder = JSONDecoder.snakeCaseDecoder(),
                                          failsOnEmptyData: Bool = true) -> Single<PaginationModel<D>> {
    return flatMap { resp -> Single<PaginationModel<D>> in
      let model = try resp.map(type, atKeyPath: keyPath, using: decoder, failsOnEmptyData: failsOnEmptyData)
      let linkHeader: String = resp.response?.allHeaderFields["Link"] as? String ?? ""
      let nextPagelinkContent = (linkHeader.components(separatedBy: ",").filter { $0.contains("next") }.first ?? "")
      
      let regex = try NSRegularExpression(pattern: "page=(\\d+)")
      let regxRange = NSRange(location: 0, length: nextPagelinkContent.utf16.count)
      let result = regex.firstMatch(in: nextPagelinkContent, options: [], range: regxRange)
      
      guard let range = result?.range,
            let pageRange = Range(range, in: nextPagelinkContent) else { return .just(PaginationModel(nextPage: nil, data: model)) }
      let page = String(nextPagelinkContent[pageRange]).replacingOccurrences(of: "page=", with: "")
      return .just(PaginationModel(nextPage: Int(page), data: model))
    }
  }
  
}
