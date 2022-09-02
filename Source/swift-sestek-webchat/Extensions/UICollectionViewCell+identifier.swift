//
//  UICollectionViewCell+identifier.swift
//  swift-sestek-webchat
//
//  Created by Ömer Sezer on 19.08.2022.
//

import UIKit

extension UICollectionViewCell {
    static var identifier: String {
        return String(describing: self.self)
    }
}
