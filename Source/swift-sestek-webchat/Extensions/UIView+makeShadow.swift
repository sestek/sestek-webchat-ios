//
//  UIView+makeShadow.swift
//  sestek-chatbot-lib
//
//  Created by Kagan Girgin on 20.07.2022.
//

import UIKit

extension UIView {
    func makeShadow() {
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowOpacity = 0.2
        self.layer.shadowRadius = 2.0
        self.clipsToBounds = false
        self.layer.masksToBounds = false
    }
}
