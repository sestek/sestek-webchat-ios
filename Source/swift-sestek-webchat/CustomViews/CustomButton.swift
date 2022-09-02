//
//  CustomButton.swift
//  sestek-chatbot-lib
//
//  Created by Ömer Sezer on 15.08.2022.
//

import UIKit

class CustomButton: UIButton {
    
    enum ButtonTypes: Int {
        case primary
    }
    
    // MARK: initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupUI()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.setupUI()
    }

    var currentCustomType: ButtonTypes = .primary

    var customType: ButtonTypes {
        get { return self.currentCustomType }
        set {
            self.currentCustomType = newValue
            setupUI()
        }
    }
    
    var value: String?
    
    private func setupUI() {
        if #available(iOS 15.0, *) {
            self.configuration = nil
        }
        self.titleLabel?.font = .systemFont(ofSize: 15)
        switch customType {
        case .primary:
            self.backgroundColor = .backgroundColor
            self.tintColor = .tintColor
            self.setTitleColor(.tintColor, for: .normal)
            self.layer.cornerRadius = 6
        }
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: 45)
        ])
    }
}
