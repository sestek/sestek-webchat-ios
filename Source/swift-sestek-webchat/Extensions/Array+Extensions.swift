//
//  Array+Extensions.swift
//  sestek-webchat-ios
//
//  Created by Tolga Taner on 24.05.2023.
//

import Foundation

extension Array {
  subscript(safe index: Index) -> Element? {
    0 <= index && index < count ? self[index] : nil
  }
}
