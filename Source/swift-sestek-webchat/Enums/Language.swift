//
//  Language.swift
//  swift-sestek-webchat
//
//  Created by Ömer Sezer on 31.08.2022.
//

import UIKit

enum Language: String {
    case english
    case arabic
    
    init(languageCode: String) {
        switch languageCode {
        case "en": self = .english
        case "ar": self = .arabic
        default: self = .english
        }
    }
    
    var semanticContentAttribute: UISemanticContentAttribute {
        switch self {
        case .arabic: return .forceRightToLeft
        default: return .forceLeftToRight
        }
    }
    
    var textAlignment: NSTextAlignment {
        switch self {
        case .arabic: return .right
        default: return .left
        }
    }
}
