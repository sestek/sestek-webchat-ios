//
//  ConversationRequestModel.swift
//  swift-sestek-webchat
//
//  Created by Ömer Sezer on 6.08.2022.
//

import Foundation

class ConversationRequestModel: Encodable {
    let timestamp: Date
    let message: String
    let customAction: String
    let customActionData: String?
    let clientId: String
    let tenant: String
    let channel: String
    let project: String
    let conversationId: String
    let fullName: String
    let userAgent: String
    let browserLanguage: String // BURASI DİNAMİK İSTENECEK
    
    init(timestamp: Date = Date(), message: String = "start_message_1234", customAction: String =  "startOfConversation", customActionData: String? = "startOfConversation", clientId: String, tenant: String, channel: String, project: String, conversationId: String = UUID().uuidString, fullName: String, userAgent: String = "USERAGENT EKLENECEK", browserLanguage: String = "tr") {
        self.timestamp = timestamp
        self.message = message
        self.customAction = customAction
        self.customActionData = customActionData
        self.clientId = clientId
        self.tenant = tenant
        self.channel = channel
        self.project = project
        self.conversationId = conversationId.contains("Mobil") ? conversationId : "Mobil\(conversationId)"
        self.fullName = fullName
        self.userAgent = userAgent
        self.browserLanguage = browserLanguage
    }
}
