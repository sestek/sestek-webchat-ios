//
//  UIImage+Extension.swift
//  swift-sestek-webchat
//
//  Created by Ömer Sezer on 22.08.2022.
//

import Foundation
import UIKit

extension UIImage {
    static let ic_logo = imageWithBundle("knovvu_logo")
    static let ic_hide = imageWithBundle("ic_hide")
    static let ic_close = imageWithBundle("ic_close")
    static let ic_button_knovvu_logo = imageWithBundle("ic_button_knovvu_logo")
}

extension UIImage {
    convenience init?(url: URL?) {
        guard let url = url else { return nil }
        do {
            self.init(data: try Data(contentsOf: url))
        } catch {
            print("Cannot load image from url: \(url) with error: \(error)")
            return nil
        }
    }
    
    static func imageWithBundle(_ name: String) -> UIImage? {
        if let image = UIImage(named: name, in: Bundle.sestekBundle(), compatibleWith: nil) {
            return image
        }
        return UIImage()
    }
}
