//
//  UITableViewCell+identifier.swift
//  sestek-chatbot-lib
//
//  Created by Kagan Girgin on 21.07.2022.
//

import UIKit

extension UITableViewCell {
    static var identifier: String {
        return String(describing: self.self)
    }
}
