//
//  NSTextAttachment+Extensions.swift
//  swift-sestek-webchat
//
//  Created by Ömer Sezer on 21.11.2022.
//

import UIKit

extension NSTextAttachment {
    func setImageWidth(width: CGFloat) {
        guard let image = image else { return }
        let ratio = image.size.height / image.size.width

        bounds = CGRect(x: bounds.origin.x, y: bounds.origin.y, width: width, height: ratio * width)
    }
}
