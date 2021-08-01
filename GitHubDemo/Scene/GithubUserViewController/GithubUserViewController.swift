//
//  GithubUserViewController.swift
//  GitHubDemo
//
//  Created by 黃韋韜 on 2021/7/27.
//

import UIKit
import RxCocoa
import RxSwift

final class GithubUserViewController: UIViewController {
  
  private lazy var searchBar: UISearchBar = {
    let searchBar: UISearchBar = UISearchBar()
    return searchBar
  }()
  
  private lazy var collectionView: UICollectionView = {
    let flowLayout: UICollectionViewFlowLayout = .init()
    flowLayout.scrollDirection = .vertical
    flowLayout.minimumLineSpacing = 10
    let collectionView: UICollectionView = .init(frame: .zero, collectionViewLayout: flowLayout)
    collectionView.delegate = self
    collectionView.dataSource = self
    collectionView.backgroundColor = .white
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    collectionView.register(GithubUserCollectionCell.self, forCellWithReuseIdentifier: GithubUserCollectionCell.describing)
    return collectionView
  }()
  
  private let viewModel: GithubUserViewModelLogic
  private let disposeBag: DisposeBag = .init()
  
  init(viewModel: GithubUserViewModelLogic) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
    setupBinding()
  }
  
  private func setupUI() {
    view.backgroundColor = .white
    navigationItem.titleView = searchBar
    
    view.addSubview(collectionView)
    collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
  }
  
  private func setupBinding() {
    searchBar.rx.searchButtonClicked
      .compactMap { [weak self] _ in self?.searchBar.text }
      .filter { $0.count > 0 }
      .subscribe(onNext: { [weak self] text in
        guard let self = self else { return }
        self.viewModel.search(queryString: text)
        self.searchBar.resignFirstResponder()
      })
      .disposed(by: disposeBag)
    
    collectionView.rx.didScroll
      .compactMap { [weak self] _ in self?.collectionView.isReachBottom }
      .distinctUntilChanged()
      .filter { $0 }
      .subscribe(onNext: { [weak self] _ in
        guard let self = self else { return }
        self.viewModel.loadNextPageData()
      })
      .disposed(by: disposeBag)
    
    viewModel.listChangeEventSignal
      .emit(onNext: { [weak self] chageEvent in
        guard let self = self else { return }
        switch chageEvent {
        case let .delete(rowIndexes):
          self.collectionView.deleteItems(at: rowIndexes.map { IndexPath(row: $0, section: 0) })
        case let .insert(rowIndexes):
          self.collectionView.insertItems(at: rowIndexes.map { IndexPath(row: $0, section: 0) })
        case let .update(rowIndexes):
          self.collectionView.reloadItems(at: rowIndexes.map { IndexPath(row: $0, section: 0) })
        }
      })
      .disposed(by: disposeBag)
  }
}

extension GithubUserViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return viewModel.dataSource.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cellDataModel = viewModel.dataSource[indexPath.row]
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellDataModel.cellIdentifier, for: indexPath)
    if let cell = cell as? GithubUserCollectionCell,
       let cellDataModel = cellDataModel as? GithubUserCellDataModel {
      cell.configure(model: cellDataModel)
    }
    return cell
  }
}

extension GithubUserViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return .init(width: collectionView.bounds.width, height: collectionView.bounds.height/6)
  }
}
