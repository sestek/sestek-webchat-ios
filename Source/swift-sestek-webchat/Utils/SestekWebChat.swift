//
//  sestek-webchat.swift
//  sestek-chatbot-lib
//
//  Created by Kagan Girgin on 19.07.2022.
//

import UIKit

public class SestekWebChat {
    
    public static let shared = SestekWebChat()
    public var customActionData: String? {
        get {
            SignalRConnectionManager.shared.customActionData
        } set {
            SignalRConnectionManager.shared.customActionData = newValue
        }
    }
    public var messageList: [PublicChatModel?]? {
        get {
            SignalRConnectionManager.shared.chat.map { PublicChatModel(text: $0.text, isOwnerSystem: $0.isOwner, date: $0.date) }
        }
    }
    public var conversationStatus: Bool {
        get {
            SignalRConnectionManager.shared.chat.count > 0
        }
    }
    public var isRoundedButtonVisible: Bool {
        get {
            FloatingRoundedButtonController.sharedInstance.isRoundedButtonVisible
        } set {
            FloatingRoundedButtonController.sharedInstance.isRoundedButtonVisible = newValue
        }
    }
    
    public func initLibrary(url: String = "https://nd-test-webchat.sestek.com/chathub", defaultConfiguration: DefaultConfiguration, customConfiguration: CustomConfiguration = CustomConfiguration.config) {
        SignalRConnectionManager.setup(with: SignalRConnectionManager.Settings(url: url, defaultConfiguration: defaultConfiguration, customConfiguration: customConfiguration))
        SignalRConnectionManager.shared.operationsDelegate = self
        FloatingRoundedButtonController.sharedInstance.button.isHidden = false
    }
    
    public func startConversation() {
        SignalRConnectionManager.shared.startConversation() { [weak self] in
            self?.presentChat()
        } onConversationStarted: { } onError: { error in
            print(error?.description ?? "")
        }
    }
    
    public func endConversation() {
        SignalRConnectionManager.shared.endConversation { } onError: { error in }
    }
    
    public func triggerVisible(_ from: UIViewController) {
        SignalRConnectionManager.shared.triggerVisible { [weak self] in
            self?.presentChat()
        }
    }
    
    private func presentChat() {
        FloatingRoundedButtonController.sharedInstance.updatePopoverVisibility(to: .open)
    }
}

extension SestekWebChat: SignalRConnectionManagerOpeartionsDelegate {
    func onError(error: String?) {
        print(error?.description ?? "")
    }
}
