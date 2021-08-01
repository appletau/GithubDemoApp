//
//  GithubUserViewModel.swift
//  GitHubDemo
//
//  Created by 黃韋韜 on 2021/7/31.
//

import Foundation
import RxCocoa
import RxSwift

protocol GithubUserViewModelLogic: AnyObject {
  func search(queryString: String)
  func loadNextPageData()
  var dataSource: [PaginationControllerItem] { get }
  var listChangeEventSignal: Signal<DataListChangEvent> { get }
}

final class GithubUserViewModel: GithubUserViewModelLogic {
  var dataSource: [PaginationControllerItem] {
    return paginationController.dataList
  }
  
  lazy var listChangeEventSignal: Signal<DataListChangEvent> = paginationController.dataListUpdateSignal.asSignal()

  private var queryString: String = ""
  private let paginationController: PaginationControllerLogic
  private let repository: GithubSearchRepositoryLogic
  
  init(repository: GithubSearchRepositoryLogic,
       paginationController: PaginationControllerLogic) {
    self.paginationController = paginationController
    self.repository = repository
  }
  
  func search(queryString: String) {
    self.queryString = queryString
    paginationController.reloadPageData()
  }
  
  func loadNextPageData() {
    paginationController.fetchNextPageData()
  }
}

extension GithubUserViewModel: PaginationControllerDelegate {
  func getPageData(nextPage: Int, perPageCount: Int) -> Single<PaginationDataSourece?> {
    return repository.getUser(queryString: queryString,
                              page: nextPage,
                              perPage: perPageCount)
      .map { (paginationModel) -> PaginationDataSourece?  in
        let pageItmes = paginationModel.data.items.map { GithubUserCellDataModel(name: $0.login, avatarUrl: $0.avatarUrl) }
        let nextPage = paginationModel.nextPage ?? -1
        return PaginationDataSourece(pageItems: pageItmes, nextPage: nextPage)
      }
  }
}
