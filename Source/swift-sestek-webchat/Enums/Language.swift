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
    var semanticValue: String {
        switch semanticContentAttribute {
        case .forceRightToLeft: return "rtl"
        default: return "ltr"
        }
    }
    var textAlignment: NSTextAlignment {
        switch self {
        case .arabic: return .right
        default: return .left
        }
    }
    
    var textAlignmentValue: String {
        switch textAlignment {
        case .left: return "left"
        case .center: return "center"
        case .right: return "right"
        default: return "left"
        }
    }
}
