//
//  UIImageView+Extensions.swift
//  swift-sestek-webchat
//
//  Created by Ömer Sezer on 19.08.2022.
//

import UIKit
import SDWebImage

extension UIImageView {
    func setImage(with urlString: String?, completion: @escaping () -> () = {}) {
        guard let urlString = urlString else { return }
        sd_setImage(with: URL(string: urlString)) { _, _, _, _ in
            completion()
        }
    }
}
