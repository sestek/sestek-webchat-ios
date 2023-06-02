//
//  UIButton+Extension.swift
//  sestek-webchat-ios
//
//  Created by Tolga Taner on 2.06.2023.
//

import UIKit

extension UIButton {
    var titleText: String {
        get {
            title(for: .normal) ?? ""
        } set {
            UIView.performWithoutAnimation { [weak self] in
                guard let self = self else { return }
                self.setTitle(newValue, for: .normal)
                self.layoutIfNeeded()
            }
        }
    }
}
