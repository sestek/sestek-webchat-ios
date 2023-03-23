//
//  AppDelegate.swift
//  swift-sestek-webchat-example
//
//  Created by Ömer Sezer on 6.08.2022.
//

import UIKit
import sestek_webchat_ios

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let defaultConfiguration = DefaultConfiguration(clientId: "mobile-testing", tenant: "Tayfun", channel: "NdaInfoBip", project: "GocIdaresi_TR", fullName: "Ömer Sezer",customActionData: "testing_customdata")
        SestekWebChat.shared.initLibrary(defaultConfiguration: defaultConfiguration)
        return true
    }
}

