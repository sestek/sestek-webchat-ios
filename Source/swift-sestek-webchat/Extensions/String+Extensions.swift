//
//  String+Extensions.swift
//  sestek-chatbot-lib
//
//  Created by Ömer Sezer on 15.08.2022.
//

import NaturalLanguage

extension String {
    func height(constraintedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let label =  UILabel(frame: CGRect(x: 0, y: 0, width: width, height: .greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.text = self
        label.font = font
        label.sizeToFit()
        return label.frame.height
     }
    
    func getDate(formatter: DateFormatter) -> Date? {
        let date = formatter.date(from: self)
        return date
    }
    
    func getDetectedLanguage() -> String? {
        if #available(iOS 12.0, *) {
            let recognizer = NLLanguageRecognizer()
            recognizer.processString(self)
            guard let languageCode = recognizer.dominantLanguage?.rawValue else { return nil }
            return languageCode
        } else {
            return nil
        }
    }

    func setURLTag() -> String {
        var mutableString: String = self
        let regex = #"((https?|ftps?):\/\/[^"<\s]+)(?![^<>]*>|[^"]*?<\/a)"#
        let urlWithoutHTMLTagRegex: NSRegularExpression = try! NSRegularExpression(pattern:
                                                                                regex, options: .caseInsensitive)
    
        let tagMatches = urlWithoutHTMLTagRegex.matches(in: mutableString,
                                       options: .reportProgress,
                                       range: NSRange(startIndex..., in: mutableString))
        tagMatches.forEach { match in
            if let range = Range(match.range, in: mutableString) {
                mutableString = mutableString.replacingOccurrences(of: self[range], with: "<a href=\(self[range])>\(self[range])</a>")
            }
        }
        return mutableString
    }
    
    private func slice(from: String, to: String) -> String? {
        guard let rangeFrom = range(of: from)?.upperBound else { return nil }
        guard let rangeTo = self[rangeFrom...].range(of: to)?.lowerBound else { return nil }
        return String(self[rangeFrom..<rangeTo])
    }
    
    func convertStrikethrough() -> String {
        do {
            var mutableString = self
            let regex = try NSRegularExpression(pattern:"~~(.*)~~")
            let matches = regex.matches(in: self, options: [], range: NSMakeRange(0, mutableString.count))
            matches.forEach { match in
                if let range = Range(match.range, in: mutableString), let slicedText = slice(from: "~~", to: "~~") {
                    mutableString = mutableString.replacingOccurrences(of: mutableString[range], with: "<s>\(slicedText)</s>")
                }
            }
            return mutableString
        } catch { return self }
    }
}
