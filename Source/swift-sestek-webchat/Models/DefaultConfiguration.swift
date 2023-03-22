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
    let isVoiceRecordingEnabled: Bool
    let customAction: String
    let customActionData: String
    
    public init(clientId: String, tenant: String, channel: String, project: String, fullName: String, isVoiceRecordingEnabled: Bool = false, customAction: String = "",customActionData: String = "") {
        self.clientId = clientId
        self.tenant = tenant
        self.channel = channel
        self.project = project
        self.fullName = fullName
        self.isVoiceRecordingEnabled = isVoiceRecordingEnabled
        self.customAction = customAction
        self.customActionData = customActionData
    }
    
    public static var config: DefaultConfiguration?
}
