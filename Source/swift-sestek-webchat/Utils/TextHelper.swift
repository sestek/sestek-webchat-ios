//
//  StringHelper.swift
//  swift-sestek-webchat
//
//  Created by Ömer Sezer on 31.08.2022.
//

import Foundation

struct CustomText {
    var text: String?
    var language: Language
}

final class TextHelper {
    func getTextsWithAttributes(_ text: String?) -> [CustomText] {
        var texts: [CustomText] = []
        if let detectedLanguage = text?.getDetectedLanguage() {
            texts.append(CustomText(text: text, language: Language(languageCode: detectedLanguage)))
        } else {
            let splittedTexts = text?.components(separatedBy: "\n")
                .filter({ !$0.isEmpty })
            splittedTexts?.forEach { splittedText in
                if let detectedLanguage = splittedText.getDetectedLanguage() {
                    texts.append(CustomText(text: splittedText, language: Language(languageCode: detectedLanguage)))
                }
            }
        }
        return texts
    }
    
    func getTextLanguage(_ text: String?) -> Language? {
        if let detectedLanguage = text?.getDetectedLanguage() {
            return Language(languageCode: detectedLanguage)
        }
        return nil
    }
}
