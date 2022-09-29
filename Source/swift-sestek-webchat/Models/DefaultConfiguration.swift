//
//  DefaultConfiguration.swift
//  swift-sestek-webchat
//
//  Created by Ömer Sezer on 21.09.2022.
//

import Foundation

public struct DefaultConfiguration {
    let clientId: String
    let tenant: String
    let channel: String
    let project: String
    let fullName: String
    
    public init(clientId: String, tenant: String, channel: String, project: String, fullName: String) {
        self.clientId = clientId
        self.tenant = tenant
        self.channel = channel
        self.project = project
        self.fullName = fullName
    }
}
