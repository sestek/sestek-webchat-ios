//
//  Bundle+Extension.swift
//  swift-sestek-webchat
//
//  Created by Ömer Sezer on 22.08.2022.
//

import Foundation

private class BundleToken {}

extension Bundle {
    static func sestekBundle() -> Bundle {

        let candidates = [
            Bundle.main.resourceURL,
            Bundle(for: BundleToken.self).resourceURL,
            Bundle.main.bundleURL,
        ]

        let bundleNames = [
            "SestekWebchatBundle"
        ]

        for bundleName in bundleNames {
            for candidate in candidates {
                let bundlePath = candidate?.appendingPathComponent(bundleName + ".bundle")
                if let bundle = bundlePath.flatMap(Bundle.init(url:)) {
                    return bundle
                }
            }
        }

        return Bundle(for: BundleToken.self)
    }
}
