//
//  GithubUserCollectionCell.swift
//  GitHubDemo
//
//  Created by 黃韋韜 on 2021/7/31.
//

import UIKit
import Kingfisher

final class GithubUserCollectionCell: UICollectionViewCell {
  private lazy var avatarImageView: UIImageView = {
    let imageView: UIImageView = .init()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()
  
  private lazy var nameLabel: UILabel = {
    let label: UILabel = .init()
    label.numberOfLines = 2
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func prepareForReuse() {
    avatarImageView.kf.cancelDownloadTask()
    nameLabel.text = ""
    super.prepareForReuse()
  }
  
  func configure(model: GithubUserCellDataModel) {
    avatarImageView.kf.setImage(with: model.avatarUrl)
    nameLabel.text = "name: \(model.name)"
  }
  
  private func setupUI() {
    contentView.addSubview(avatarImageView)
    avatarImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
    avatarImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
    avatarImageView.widthAnchor.constraint(equalTo: avatarImageView.heightAnchor).isActive = true
    avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15).isActive = true
    
    contentView.addSubview(nameLabel)
    nameLabel.topAnchor.constraint(equalTo: avatarImageView.topAnchor).isActive = true
    nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 5).isActive = true
    nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: 15).isActive = true
  }
}
