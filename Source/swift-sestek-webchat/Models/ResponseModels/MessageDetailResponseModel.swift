//
//  MessageDetailResponseModel.swift
//  swift-sestek-webchat
//
//  Created by Ömer Sezer on 14.08.2022.
//

import Foundation

struct MessageDetailResponseModel: Decodable {
    let type, id, timestamp: String?
    let localTimestamp, localTimezone: String?
    let serviceURL, channelID: String?
    let from: FromResponseModel?
    let conversation: ConversationResponseModel?
    let recipient: FromResponseModel?
    let attachmentLayout: AttachmentLayoutEnums?
    let textFormat, membersAdded, membersRemoved: String?
    let reactionsAdded, reactionsRemoved, topicName, historyDisclosed: String?
    let locale: String?
    let text, speak: String?
    let inputHint, summary, suggestedActions: String?
    let attachments: [AttachmentResponseModel]?
    let entities: [EntitiesResponseModel?]?
    let channelData: ChannelDataResponseModel?
    let action: String?
    let replyToID: String?
    let label, valueType, value, name: String?
    let relatesTo, code, expiration, importance: String?
    let deliveryMode, listenFor, textHighlights, semanticAction: String?
    let callerID: String?
}

struct ChannelDataResponseModel: Decodable {
    let projectName: String?
    let audioOutputSettings: AudioOutputSettingsResponseModel?
    let generateChatOutput, returnSrText: Bool?
    let audioForSr, srResult: String?
    let stopRedirection: Bool?
    let successAndErrorStatus: SuccessAndErrorStatusResponseModel?
    let customAction, customActionData, audioFromTTS, textFromSr: String?
}

struct AudioOutputSettingsResponseModel: Decodable {
    let generate, putInStructuredPart: Bool?
    let expectedFormat: String?
}

struct SuccessAndErrorStatusResponseModel: Decodable {
    let isSuccessful: Bool?
    let errorCode, errorMessage: String?
}

struct ConversationResponseModel: Decodable {
    let isGroup, conversationType: String?
    let id: String?
    let name, aadObjectID, role, tenantID: String?
}

struct FromResponseModel: Decodable {
    let id, name: String?
    let aadObjectID, role: String?
}

struct AttachmentResponseModel: Decodable {
    let contentType: String?
    let contentURL: String?
    var content: ContentResponseModel?
    let name, thumbnailURL: String?
}

struct ContentResponseModel: Decodable {
    let title, subtitle, text: String?
    var images: [ImageResponseModel]?
    let buttons: [ButtonResponseModel]?
    let tap: String?
}

struct ButtonResponseModel: Decodable {
    let type, title: String?
    let image, text, displayText: String?
    let value: String?
    let channelData: String?
}

struct ImageResponseModel: Decodable {
    let url: String?
    let alt: String?
    let tap: ButtonResponseModel?
}

struct EntitiesResponseModel: Decodable {
    let type: String?
    let address: String?
    let geo: GeoResponseModel?
}

struct GeoResponseModel: Decodable {
    let elevation: Int?
    let latitude, longitude: Double?
    let type, name: String?
}

enum AttachmentLayoutEnums: String, Decodable {
    case carousel = "carousel"
    case unknown
}
