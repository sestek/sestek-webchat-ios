//
//  SelfSizingCollectionView.swift
//  sestek-webchat-ios
//
//  Created by Tolga Taner on 24.05.2023.
//

import UIKit

final class SelfSizingCollectionView: UICollectionView {
    
    override var contentSize: CGSize {
        didSet {
            if oldValue.height != contentSize.height  {
                invalidateIntrinsicContentSize()
            }
        }
    }

    override var intrinsicContentSize: CGSize {
        layoutIfNeeded()
         return CGSize(width: UIView.noIntrinsicMetric,
                      height: contentSize.height)
    }
}
