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
        SestekWebChat.sharedInstance.initLibrary()
        return true
    }
}

