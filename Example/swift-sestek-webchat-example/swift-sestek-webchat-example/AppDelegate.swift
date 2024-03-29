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
        let defaultConfiguration = DefaultConfiguration(clientId: "mobile-testing", tenant: "Hakan", channel: "NdUi", project: "ChatBotMessages", fullName: "Ömer Sezer", customActionData: "{\"channel\":\"mobileapp\",\"operate\":\"ios\"}")
        SestekWebChat.shared.initLibrary(url: "https://nd-test-webchat.sestek.com/chathub", defaultConfiguration: defaultConfiguration)
        return true
    }
}

