//
//  ViewControllerFactory.swift
//  GitHubDemo
//
//  Created by 黃韋韜 on 2021/8/1.
//

import UIKit

protocol ViewControllerFactoryLogic {
  func createGithubUserViewController() -> UIViewController
}

struct ViewControllerFactory: ViewControllerFactoryLogic {
  func createGithubUserViewController() -> UIViewController {
    let paginationController: PaginationController = .init(loadMoreCellIdentifier: CollectionLoadMoreCell.describing)
    let viewModel: GithubUserViewModel = .init(repository: GithubSearchRepository(),
                                               paginationController: paginationController)
    paginationController.delegate = viewModel
    return GithubUserViewController(viewModel: viewModel)
  }
}
