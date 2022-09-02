//
//  Extensions.swift
//  sestek-chatbot-lib
//
//  Created by Kagan Girgin on 19.07.2022.
//

import UIKit

extension UIViewController {
    static func loadFromNib() -> Self {
        func instantiateFromNib<T: UIViewController>() -> T {
            let bundle = Bundle(for: SestekWebChat.self)
            return T.init(nibName: String(describing: T.self), bundle: bundle)
        }

        return instantiateFromNib()
    }
}
