//
//  UIColor+Extension.swift
//  swift-sestek-webchat
//
//  Created by Ömer Sezer on 22.08.2022.
//

import UIKit.UIColor

extension UIColor {
    static let backgroundColor = UIColor(red: (168.0 / 255.0), green: (171.0 / 255.0), blue: (228.0 / 255.0), alpha: 1.0)
    static let barBackgroundColor = UIColor(red: (138.0 / 255.0), green: (141.0 / 255.0), blue: (198.0 / 255.0), alpha: 1.0)
    static let tintColor = UIColor(red: (255.0 / 255.0), green: (255.0 / 255.0), blue: (255.0 / 255.0), alpha: 1.0)
    
    var hexString: String? {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0

        let multiplier = CGFloat(255.999999)

        guard self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) else {
            return nil
        }

        if alpha == 1.0 {
            return String(
                format: "#%02lX%02lX%02lX",
                Int(red * multiplier),
                Int(green * multiplier),
                Int(blue * multiplier)
            )
        }
        else {
            return String(
                format: "#%02lX%02lX%02lX%02lX",
                Int(red * multiplier),
                Int(green * multiplier),
                Int(blue * multiplier),
                Int(alpha * multiplier)
            )
        }
    }
}
