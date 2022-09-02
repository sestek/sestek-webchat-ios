//
//  ConnectionInfoModel.swift
//  swift-sestek-webchat
//
//  Created by Ömer Sezer on 6.08.2022.
//

import Foundation

final class ConnectionInfoModel {
    var clientId: String
    var tenant: String
    var channel: String
    var project: String
    var conversationId: String
    var fullName: String
    var sessionId: String?
    
    init(clientId: String, tenant: String, channel: String, project: String, conversationId: String, fullName: String) {
        self.clientId = clientId
        self.tenant = tenant
        self.channel = channel
        self.project = project
        self.conversationId = conversationId
        self.fullName = fullName
    }
}
