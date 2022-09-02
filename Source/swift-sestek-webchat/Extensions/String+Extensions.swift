//
//  String+Extensions.swift
//  sestek-chatbot-lib
//
//  Created by Ömer Sezer on 15.08.2022.
//

import NaturalLanguage

extension String {
    func getDate(formatter: DateFormatter) -> Date? {
        let date = formatter.date(from: self)
        return date
    }
    
    func getDetectedLanguage() -> String? {
        let recognizer = NLLanguageRecognizer()
        recognizer.processString(self)
        guard let languageCode = recognizer.dominantLanguage?.rawValue else { return nil }
        return languageCode
    }
}
