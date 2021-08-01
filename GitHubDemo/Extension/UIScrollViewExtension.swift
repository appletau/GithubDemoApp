//
//  UIScrollViewExtension.swift
//  GitHubDemo
//
//  Created by 黃韋韜 on 2021/8/1.
//

import UIKit

extension UIScrollView {
  var isReachBottom: Bool {
    return contentOffset.y >= verticalOffsetForBottom
  }
  
  var verticalOffsetForBottom: CGFloat {
    let scrollViewHeight = bounds.height
    let scrollContentSizeHeight = contentSize.height
    let bottomInset = contentInset.bottom
    let scrollViewBottomOffset = scrollContentSizeHeight > scrollViewHeight ? scrollContentSizeHeight + bottomInset - scrollViewHeight :  scrollViewHeight
    return scrollViewBottomOffset
  }
}
