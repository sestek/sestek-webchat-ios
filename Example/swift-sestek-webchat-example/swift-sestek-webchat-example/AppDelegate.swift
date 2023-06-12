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
        let defaultConfiguration = DefaultConfiguration(clientId: "mobile-testing", tenant: "Default", channel: "NdUi", project: "IGA", fullName: "Ömer Sezer", customActionData: "{\"channel\":\"mobileapp\",\"operate\":\"ios\"}")
        SestekWebChat.shared.initLibrary(url: "https://igavassistwebchat.igairport.aero:6443/chathub", defaultConfiguration: defaultConfiguration)
        return true
    }
}

