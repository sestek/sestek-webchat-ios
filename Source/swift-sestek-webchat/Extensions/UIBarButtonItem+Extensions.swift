//
//  UIBarButtonItem+Extensions.swift
//  swift-sestek-webchat
//
//  Created by Ömer Sezer on 20.09.2022.
//

import UIKit

extension UIBarButtonItem {
    static func createNavigationBarButton(image: UIImage?, target: Any?, action: Selector) -> UIBarButtonItem {
        let button = UIButton(type: .system)
        button.setImage(image, for: .normal)
        button.addTarget(target, action: action, for: .touchUpInside)
        
        let menuBarItem = UIBarButtonItem(customView: button)
        menuBarItem.customView?.translatesAutoresizingMaskIntoConstraints = false
        menuBarItem.customView?.heightAnchor.constraint(equalToConstant: 16).isActive = true
        menuBarItem.customView?.widthAnchor.constraint(equalToConstant: 16).isActive = true
        
        return menuBarItem
    }
}
