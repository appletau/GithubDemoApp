//
//  PaginationController.swift
//  Mamilove
//
//  Created by 黃韋韜 on 2020/12/16.
//  Copyright © 2020 Shang-en Info. Co.,Ltd. All rights reserved.
//

import UIKit
import RxSwift
import RxRelay

enum DataListChangEvent {
  case insert(rowIndexes: [Int]), delete(rowIndexes: [Int]), update(rowIndexes: [Int])
}

enum PaginationControllerError {
  case reloadDataFailed(error: Error), fetchNextPageData(error: Error)
}


struct LoadMoreCellItem: PaginationControllerItem {
  let cellIdentifier: String
}

struct ShimmerCellItem: PaginationControllerItem {
  let cellIdentifier: String
}

struct ShimmerCellProperty {
  let cellIdentifier: String
  let cellCount: Int
}

typealias PaginationDataSourece = (pageItems: [PaginationControllerItem], nextPage: Int)

protocol PaginationControllerDelegate: class {
  func getPageData(nextPage: Int, perPageCount: Int) -> Single<PaginationDataSourece?>
}

protocol PaginationControllerItem {
  var cellIdentifier: String { get }
}

protocol PaginationControllerLogic: AnyObject {
  var dataList: [PaginationControllerItem] { get set }
  var currentState: BehaviorRelay<PageState> { get }
  var states: [AnyHashable: PageState] { get }
  var isDataEmptyRelay: BehaviorRelay<Bool> { get }
  var fetchDataErrorRelay: BehaviorRelay<PaginationControllerError?> { get }
  var nextPage: Int { get set }
  var perPageCount: Int { get }
  var dataListUpdateSignal: PublishRelay<DataListChangEvent> { get }
  var loadMoreCellIdentifier: String? { get }
  var shimmerCellProperty: ShimmerCellProperty? { get }
  var queue: DispatchQueue { get }
  func fetchNextPageData()
  func reloadPageData()
  func reset()
}

extension PaginationControllerLogic {
  func transitionToState(matching identifier: AnyHashable, withNewDataSource newDataSource: PaginationDataSourece? = nil) {
    queue.async { [weak self] in
      guard let self = self,
            let state = self.states[identifier] else { return }
      self.currentState.accept(state)
      self.currentState.value.updatePageController(self, withNewDataSource: newDataSource)
    }
  }
  
  func delete(rowIndexes: [Int]) {
    DispatchQueue.main.async {[weak self] in
      guard let self = self else { return }
      rowIndexes.sorted { $0 > $1 }.forEach { self.dataList.remove(at: $0) }
      self.dataListUpdateSignal.accept(.delete(rowIndexes: rowIndexes))
    }
  }
  
  func update(updateInfos: [(rowIndex: Int, item: PaginationControllerItem)]) {
    DispatchQueue.main.async { [weak self] in
      guard let self = self else { return }
      updateInfos.forEach { self.dataList[$0.rowIndex] = $0.item}
      
      self.dataListUpdateSignal.accept(.update(rowIndexes: updateInfos.map { $0.rowIndex }))
    }
  }
  
  func insert(items: [PaginationControllerItem]) {
    DispatchQueue.main.async {[weak self] in
      guard let self = self else { return }
      let startIndex = self.dataList.count
      self.dataList.insert(contentsOf: items, at: startIndex)
      
      let insertedRowIndexes = items.count > 0 ? Array(startIndex...startIndex+items.count-1) : []
      self.dataListUpdateSignal.accept(.insert(rowIndexes: insertedRowIndexes))
    }
  }
}

class PaginationController: PaginationControllerLogic {
  
  var dataList: [PaginationControllerItem] = []
  
  var nextPage: Int
  
  let currentState: BehaviorRelay<PageState>
  
  let states: [AnyHashable: PageState]
  
  let perPageCount: Int
  
  let dataListUpdateSignal: PublishRelay<DataListChangEvent> = PublishRelay<DataListChangEvent>()
  
  let isDataEmptyRelay: BehaviorRelay<Bool> = BehaviorRelay<Bool>(value: false)
  
  let fetchDataErrorRelay: BehaviorRelay<PaginationControllerError?> = .init(value: nil)
  
  let queue: DispatchQueue = .init(label: "PageController")
  
  weak var delegate: PaginationControllerDelegate?
  
  private var disposeBag: DisposeBag = DisposeBag()
  
  private var canLoadNextData: Bool {
    return nextPage != -1 && currentState.value is AcceptInputState
  }
  
  let loadMoreCellIdentifier: String?
  let shimmerCellProperty: ShimmerCellProperty?
  let startPage: Int

  init(loadMoreCellIdentifier: String? = nil,
       shimmerCellProperty: ShimmerCellProperty? = nil,
       nextPage: Int = 1,
       perPageCount: Int = 20) {
    self.loadMoreCellIdentifier = loadMoreCellIdentifier
    self.shimmerCellProperty = shimmerCellProperty
    let allStates: [AnyHashable: PageState] = [AcceptInputState.identifier: AcceptInputState(),
                                               ReloadDataState.identifier: ReloadDataState(),
                                               LoadNextDataState.identifier: LoadNextDataState(),
                                               FinishLoadingState.identifier: FinishLoadingState()]
    self.states = allStates
    self.currentState = BehaviorRelay<PageState>(value: allStates[AcceptInputState.identifier]!)
    self.nextPage = nextPage
    self.startPage = nextPage
    self.perPageCount = perPageCount
    setupObservable()
  }
  
  func fetchNextPageData() {
    guard canLoadNextData else { return }
    transitionToState(matching: LoadNextDataState.identifier)
    getPageData()
  }
  
  func reloadPageData() {
    disposeBag = DisposeBag()
    fetchDataErrorRelay.accept(nil)
    isDataEmptyRelay.accept(false)
    nextPage = startPage
    transitionToState(matching: ReloadDataState.identifier)
    setupObservable()
    getPageData()
  }
  
  func reset() {
    disposeBag = DisposeBag()
    dataList = []
    fetchDataErrorRelay.accept(nil)
    isDataEmptyRelay.accept(false)
    nextPage = startPage
    transitionToState(matching: AcceptInputState.identifier)
    setupObservable()
  }
  
  private func setupObservable() {
    currentState
      .filter { $0 is AcceptInputState }
      .skip(1)
      .subscribe(onNext: { [weak self] _ in
        guard let self = self,
              self.fetchDataErrorRelay.value == nil else { return }
        self.isDataEmptyRelay.accept(self.dataList.count == 0 )
      })
      .disposed(by: self.disposeBag)
    
    dataListUpdateSignal
      .filter { [weak self] _ in self?.currentState.value is AcceptInputState }
      .compactMap { [weak self] _ in self?.dataList.count == 0  }
      .bind(to: isDataEmptyRelay)
      .disposed(by: self.disposeBag)
  }
  
  private func getPageData() {
    fetchDataErrorRelay.accept(nil)
    self.delegate?.getPageData(nextPage: self.nextPage, perPageCount: self.perPageCount)
      .subscribe(onSuccess: { (pageDataSourece) in
        self.transitionToState(matching: FinishLoadingState.identifier, withNewDataSource: pageDataSourece)
      }, onError: { error in
        self.transitionToState(matching: FinishLoadingState.identifier)
        if self.currentState.value is LoadNextDataState {
          self.fetchDataErrorRelay.accept(.fetchNextPageData(error: error))
        } else {
          self.fetchDataErrorRelay.accept(.reloadDataFailed(error: error))
        }
      })
      .disposed(by: self.disposeBag)
  }
  
}
