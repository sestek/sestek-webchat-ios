//
//  UIViewController+Extensions.swift
//  swift-sestek-webchat
//
//  Created by Ömer Sezer on 31.08.2022.
//

import SafariServices
import UIKit

extension UIViewController {
    func showStandardAlert(title: String, message: String?) {
        AlertUtil().showStandardAlert(parentController: self, title: title, message: message ?? "")
    }
    
    func showStandardAlert(message: String?) {
        AlertUtil().showStandardAlert(parentController: self, message: message ?? "")
    }
    
    func showStandardAlertWithCompletion(title: String, message: String, completion: @escaping (() -> Void)) {
        AlertUtil().showStandardAlertWithCompletion(parentController: self, title: title, message: message, completion: completion)
    }
    
    func showStandardAlertWithOptions(title: String, message: String, firstOptionTitle: String, secondOptionTitle: String, firstOptionAction: @escaping (() -> Void), secondOptionAction: @escaping (() -> Void)) {
        AlertUtil().showStandardAlertWithOptions(parentController: self, title: title, message: message, firstOptionTitle: firstOptionTitle, secondOptionTitle: secondOptionTitle, firstOptionAction: firstOptionAction, secondOptionAction: secondOptionAction)
    }
    
    func showStandardAlertAndGoBack(parentController: UIViewController, title: String, message: String) {
        AlertUtil().showStandardAlertAndGoBack(parentController: self, title: title, message: message)
    }
    
    func showStandardAlertWithAction(parentController: UIViewController, title: String, message: String, optionAction: @escaping (() -> Void)) {
        AlertUtil().showStandardAlertWithAction(parentController: self, title: title, message: message, optionAction: optionAction)
    }
}

extension UIViewController {
    func openSFSafariViewController(with url: URL) {
        let config = SFSafariViewController.Configuration()
        config.entersReaderIfAvailable = true
        present(SFSafariViewController(url: url, configuration: config), animated: true)
    }
}
