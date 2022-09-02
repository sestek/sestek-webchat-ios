//
//  Date+Extensions.swift
//  swift-sestek-webchat
//
//  Created by Ömer Sezer on 7.08.2022.
//

import Foundation

extension Date {
    func getAsString(_ formatter: DateFormatter) -> String {
        return formatter.string(from: self)
    }
    
    var millisecondsSince1970:Int64 {
        Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }
}
