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
    
    internal static let sharedInstance = SignalRConnectionManager(with: URL(string: "https://nd-test-webchat.sestek.com/chathub")!)
    
    weak var messagingDelegate: SignalRConnectionManagerMessagingDelegate?
    weak var operationsDelegate: SignalRConnectionManagerOpeartionsDelegate?
    private var connection: HubConnection
    var isConnected: Bool = false
    var connectionInfo: ConnectionInfoModel?
    var chat: [ChatModel] = []
    var customActionData: String?
    
    public init(with url: URL) {
        connection = HubConnectionBuilder(url: url)
            .withLogging(minLogLevel: .error)
            .withAutoReconnect()
            .build()
        
        connection.on(method: "ReceiveMessage", callback: { [weak self] (id: String, message: String) in
            if let data = message.data(using: .utf8), let model = try? JSONDecoder().decode(MessageDetailResponseModel.self, from: data) {
                self?.connectionInfo?.sessionId = model.id
                self?.messagingDelegate?.onNewMessageReceived(messageDetail: model)
            }
            return
        })
        
        connection.on(method: "ChatMessageStatusChangeEvent") { message in
            print("ChatMessageStatusChangeEvent: \(message)")
        }
        
        connection.start()
    }
    
    func startConversation(clientId: String, tenant: String, channel: String, project: String, fullName: String, onConversationStartingProcessStarted: @escaping (() -> Void), onConversationStarted: @escaping (() -> Void), onError: @escaping ((_ error: String?) -> Void))  {
        if SignalRConnectionManager.sharedInstance.chat.count > 0 {
            onConversationStartingProcessStarted()
            return
        }
        onConversationStartingProcessStarted()
        let conversationRequestModel = ConversationRequestModel(clientId: clientId, tenant: tenant, channel: channel, project: project, fullName: fullName)
        if let jsonData = try? JSONEncoder().encode(conversationRequestModel), let jsonString = String(data: jsonData, encoding: .utf8) {
            connection.invoke(method: "StartConversation", jsonString) { error in
                if let error = error {
                    onError(error.localizedDescription)
                    return
                }
                self.connectionInfo = ConnectionInfoModel(clientId: clientId, tenant: tenant, channel: channel, project: project, conversationId: conversationRequestModel.conversationId, fullName: conversationRequestModel.fullName)
                self.isConnected = true
                onConversationStarted()
            }
        }
    }
    
    func sendMessage(message: String, onMessageSent: @escaping (() -> Void), onError: @escaping ((_ error: String) -> Void)) {
        if !isConnected {
            messagingDelegate?.onError(error: "You are not connected")
            return
        }
        
        guard let info = connectionInfo else {
            messagingDelegate?.onError(error: "Connection info not found")
            return
        }
        let conversationRequestModel = ConversationRequestModel(message: message, customAction: "sendMessage", customActionData: nil, clientId: info.clientId, tenant: info.tenant, channel: info.channel, project: info.project, conversationId: info.conversationId, fullName: info.fullName)
        if let jsonData = try? JSONEncoder().encode(conversationRequestModel), let jsonString = String(data: jsonData, encoding: .utf8) {
            connection.invoke(method: "SendMessage", arguments: [connectionInfo?.conversationId ?? "", message, "sendMessage", "", info.project, info.clientId, info.channel, info.tenant, info.fullName]) { error in
                if let error = error {
                    onError(error.localizedDescription)
                    return
                }
                onMessageSent()
            }
        }
    }
    
    func continueConversation(onConversationContinued: @escaping (() -> Void), onError: @escaping ((_ error: String) -> Void)) {
        
    }
    
    func endConversation(onConversationEnded: @escaping (() -> Void), onError: @escaping ((_ error: String) -> Void)) {
        connection.invoke(method: "EndConversation") { error in
            SignalRConnectionManager.sharedInstance.chat = []
            onConversationEnded()
        }
    }
    
}
