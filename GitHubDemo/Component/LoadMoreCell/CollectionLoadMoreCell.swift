//
//  CollectionLoadMoreCell.swift
//  GitHubDemo
//
//  Created by 黃韋韜 on 2021/8/1.
//

import UIKit

final class CollectionLoadMoreCell: UICollectionViewCell {
  private lazy var indicator: UIActivityIndicatorView = {
    let indicator = UIActivityIndicatorView()
    indicator.color = .init(white: 74/255, alpha: 1)
    indicator.translatesAutoresizingMaskIntoConstraints = false
    return indicator
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func startAnimating() {
    indicator.startAnimating()
  }
  
  func stopAnimating() {
    indicator.stopAnimating()
  }
  
  private func setupUI() {
    isUserInteractionEnabled = false
    contentView.addSubview(indicator)
    indicator.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    indicator.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
  }
}
