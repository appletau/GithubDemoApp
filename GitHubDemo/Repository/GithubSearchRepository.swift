//
//  GithubSearchRepository.swift
//  GitHubDemo
//
//  Created by 黃韋韜 on 2021/7/31.
//

import Foundation
import RxSwift
import Moya

protocol GithubSearchRepositoryLogic: BaseRepository {
  func getUser(queryString: String,
               page: Int,
               perPage: Int) -> Single<PaginationModel<UserSearchResultModel>>
}

final class GithubSearchRepository: BaseRepository, GithubSearchRepositoryLogic {
  func getUser(queryString: String,
               page: Int,
               perPage: Int) -> Single<PaginationModel<UserSearchResultModel>> {
    return sendRequest(target: GithubSearchAPI.SearchUser(queryString: queryString,
                                                          page: page,
                                                          perPage: perPage))
      .mapToPaginationModel(UserSearchResultModel.self)
  }
}
