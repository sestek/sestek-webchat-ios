//
//  CustomConfiguration.swift
//  swift-sestek-webchat
//
//  Created by Ömer Sezer on 28.09.2022.
//

import UIKit

public struct CustomConfiguration {
    let headerColor: UIColor
    let headerText: String
    let bottomColor: UIColor
    let bottomInputText: String
    let incomingIcon: ResourceType
    let incomingText: String
    let incomingTextColor: UIColor
    let outgoingIcon: ResourceType
    let outgoingText: String
    let outgoingTextColor: UIColor
    let messageColor: UIColor
    let messageBoxColor: UIColor
    let bodyColorOrImage: ResourceType
    let firstIcon: ResourceType
    let firstColor: UIColor
    let firstSize: Double
    public init(headerColor: UIColor,
                headerText: String,
                bottomColor: UIColor,
                bottomInputText: String,
                incomingIcon: ResourceType,
                incomingText: String,
                incomingTextColor: UIColor,
                outgoingIcon: ResourceType,
                outgoingText: String,
                outgoingTextColor: UIColor,
                messageColor: UIColor,
                messageBoxColor: UIColor,
                bodyColorOrImage: ResourceType,
                firstIcon: ResourceType,
                firstColor: UIColor,
                firstSize: Double) {
        self.headerColor = headerColor
        self.headerText = headerText
        self.bottomColor = bottomColor
        self.bottomInputText = bottomInputText
        self.incomingIcon = incomingIcon
        self.incomingText = incomingText
        self.incomingTextColor = incomingTextColor
        self.outgoingIcon = outgoingIcon
        self.outgoingText = outgoingText
        self.outgoingTextColor = outgoingTextColor
        self.messageColor = messageColor
        self.messageBoxColor = messageBoxColor
        self.bodyColorOrImage = bodyColorOrImage
        self.firstIcon = firstIcon
        self.firstColor = firstColor
        self.firstSize = firstSize
    }
    
    public static var config = CustomConfiguration(headerColor: .barBackgroundColor,
                                                      headerText: "Knovvu",
                                                      bottomColor: .black,
                                                      bottomInputText: "Bottom Input Text",
                                                      incomingIcon: .url(url: "https://upload.wikimedia.org/wikipedia/commons/7/70/User_icon_BLACK-01.png"),
                                                      incomingText: "User",
                                                      incomingTextColor: .black,
                                                      outgoingIcon: .image(image: .ic_logo ?? UIImage()),
                                                      outgoingText: "Knovvu",
                                                      outgoingTextColor: .black,
                                                      messageColor: .black,
                                                      messageBoxColor: .white,
                                                      bodyColorOrImage: .color(color: .barBackgroundColor),
                                                      firstIcon: .image(image: .ic_button_knovvu_logo ?? UIImage()),
                                                      firstColor: .white,
                                                      firstSize: 60)
}
