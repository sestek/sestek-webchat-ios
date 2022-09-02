//
//  UICollectionView+register.swift
//  swift-sestek-webchat
//
//  Created by Ömer Sezer on 19.08.2022.
//

import UIKit


extension UICollectionView {
    func register(cell: UICollectionViewCell.Type) {
        let bundle = Bundle(for: cell.self)
        let nib = UINib(nibName: cell.identifier, bundle: bundle)
        register(nib, forCellWithReuseIdentifier: cell.identifier)
    }
}
