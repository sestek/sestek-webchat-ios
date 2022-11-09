//
//  ChatModel.swift
//  sestek-chatbot-lib
//
//  Created by Kagan Girgin on 20.07.2022.
//

import Foundation

struct ChatModel {
    var text: String
    var attachment: AttachmentResponseModel?
    var isOwner: Bool
    var date: String?
    var layout: AttachmentLayoutEnums = .unknown
    var location: GeoResponseModel?
}
