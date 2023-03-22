//
//  SignalRConnectionManager.swift
//  swift-sestek-webchat
//
//  Created by Ömer Sezer on 6.08.2022.
//

import Foundation

protocol SignalRConnectionManagerMessagingDelegate: AnyObject {
    func onNewMessageReceived(messageDetail: MessageDetailResponseModel?)
    func onError(error: String?)
}

protocol SignalRConnectionManagerOpeartionsDelegate: AnyObject {
    func onError(error: String?)
}

final internal class SignalRConnectionManager {
    struct Settings {
        let url: String
        let defaultConfiguration: DefaultConfiguration
        let customConfiguration: CustomConfiguration
    }
    
    internal static let shared = SignalRConnectionManager()
    private static var settings: Settings?
    var isVoiceRecordingEnabled: Bool {
        get {
            DefaultConfiguration.config?.isVoiceRecordingEnabled ?? false
        }
    }
    
    weak var messagingDelegate: SignalRConnectionManagerMessagingDelegate?
    weak var operationsDelegate: SignalRConnectionManagerOpeartionsDelegate?
    
    private var connection: HubConnection?
    var isConnected: Bool = false
    var conversationId: String?
    var chat: [ChatModel] = []
    var customActionData: String?
    
    class func setup(with configuration: Settings) {
        self.settings = configuration
        CustomConfiguration.config = configuration.customConfiguration
        DefaultConfiguration.config = configuration.defaultConfiguration
    }
    
    public init() {
        guard let url = URL(string: SignalRConnectionManager.settings?.url ?? "")  else {
            print("URL is not valid")
            return
        }
        connection = HubConnectionBuilder(url: url)
            .withLogging(minLogLevel: .error)
            .withAutoReconnect()
            .build()
        
        connection?.on(method: "ReceiveMessage", callback: { [weak self] (id: String, message: String) in
            if let data = message.data(using: .utf8), let model = try? JSONDecoder().decode(MessageDetailResponseModel.self, from: data) {
                self?.messagingDelegate?.onNewMessageReceived(messageDetail: model)
            }
            return
        })
        
        connection?.on(method: "ChatMessageStatusChangeEvent") { message in
            print("ChatMessageStatusChangeEvent: \(message)")
        }
        
        connection?.start()
    }
    
    func startConversation(onConversationStartingProcessStarted: @escaping (() -> Void), onConversationStarted: @escaping (() -> Void), onError: @escaping ((_ error: String?) -> Void))  {
        if SignalRConnectionManager.shared.chat.count > 0 {
            onConversationStartingProcessStarted()
            return
        }
        onConversationStartingProcessStarted()
        guard let settings = SignalRConnectionManager.settings else {
            print("Default configuration is nil")
            return
        }
        let conversationRequestModel = ConversationRequestModel(customActionData:settings.defaultConfiguration.customActionData,clientId: settings.defaultConfiguration.clientId, tenant: settings.defaultConfiguration.tenant, channel: settings.defaultConfiguration.channel, project: settings.defaultConfiguration.project, fullName: settings.defaultConfiguration.fullName)
        if let jsonData = try? JSONEncoder().encode(conversationRequestModel), let jsonString = String(data: jsonData, encoding: .utf8) {
            connection?.invoke(method: "StartConversation", jsonString) { error in
                if let error = error {
                    onError(error.localizedDescription)
                    return
                }
                self.conversationId = conversationRequestModel.conversationId
                self.isConnected = true
                onConversationStarted()
            }
        }
    }
    
    func triggerVisible(onCoversationExists: (() -> Void)) {
        if SignalRConnectionManager.shared.chat.count > 0 {
            onCoversationExists()
            return
        }
    }
    
    func sendMessage(message: String, onMessageSent: @escaping (() -> Void), onError: @escaping ((_ error: String) -> Void)) {
        if !isConnected {
            messagingDelegate?.onError(error: "You are not connected")
            return
        }
        
        guard let settings = SignalRConnectionManager.settings else {
            messagingDelegate?.onError(error: "Connection info not found")
            return
        }
        connection?.invoke(method: "SendMessage", arguments: [conversationId ?? "", message, settings.defaultConfiguration.customAction, settings.defaultConfiguration.customActionData, settings.defaultConfiguration.project, settings.defaultConfiguration.clientId, settings.defaultConfiguration.channel, settings.defaultConfiguration.tenant, settings.defaultConfiguration.fullName]) { error in
            if let error = error {
                onError(error.localizedDescription)
                return
            }
            onMessageSent()
        }
    }
    
    func endConversation(onConversationEnded: @escaping (() -> Void), onError: @escaping ((_ error: String) -> Void)) {
        connection?.invoke(method: "EndConversation") { error in
            SignalRConnectionManager.shared.chat = []
            onConversationEnded()
        }
    }
}
