//
//  sestek-webchat.swift
//  sestek-chatbot-lib
//
//  Created by Kagan Girgin on 19.07.2022.
//

import UIKit
import IQKeyboardManagerSwift

public class SestekWebChat {
    
    public static let sharedInstance = SestekWebChat()
    private var fromVC: UIViewController?
    public var customActionData: String? {
        get {
            SignalRConnectionManager.sharedInstance.customActionData
        } set {
            SignalRConnectionManager.sharedInstance.customActionData = newValue
        }
    }
    
    public func initLibrary() {
        IQKeyboardManager.shared.enable = true
        SignalRConnectionManager.sharedInstance.operationsDelegate = self
        FloatingRoundedButtonController.sharedInstance.delegate = self
        FloatingRoundedButtonController.sharedInstance.button.isHidden = false
    }
    
    public func startConversation(clientId: String, tenant: String, channel: String, project: String, fullName: String, _ from: UIViewController) {
        SignalRConnectionManager.sharedInstance.startConversation(clientId: clientId, tenant: tenant, channel: channel, project: project, fullName: fullName) { [weak self] in
            self?.presentChat(from)
        } onConversationStarted: { } onError: { error in
            from.showStandardAlert(message: error)
        }
    }
    
    public func endConversation() {
        SignalRConnectionManager.sharedInstance.endConversation { } onError: { error in }
    }
    
    public func changeRoundedButtonVisibility(isVisible: Bool) {
        isVisible ? FloatingRoundedButtonController.sharedInstance.showButton() : FloatingRoundedButtonController.sharedInstance.hideButton()
    }
    
    private func presentChat(_ from: UIViewController) {
        self.fromVC = from
        let navigationController = UINavigationController()
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.backgroundColor = .barBackgroundColor
            navigationController.navigationBar.standardAppearance = appearance
            navigationController.navigationBar.scrollEdgeAppearance = appearance
            navigationController.navigationBar.compactAppearance = appearance
        } else {
            navigationController.navigationBar.barTintColor = .barBackgroundColor
        }
        
        navigationController.navigationBar.tintColor = .tintColor
        
        let vc = ChatViewController.loadFromNib()
        vc.bgColor = .barBackgroundColor
        
        navigationController.viewControllers = [vc]
        navigationController.modalPresentationStyle = .fullScreen
        from.present(navigationController, animated: true)
    }
}

extension SestekWebChat: SignalRConnectionManagerOpeartionsDelegate {
    func onError(error: String?) {
        print(error)
    }
}

extension SestekWebChat: FloatingRoundedButtonDelegate {
    func onButtonClicked() {
    }
}
