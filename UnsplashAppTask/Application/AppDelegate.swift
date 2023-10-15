//
//  AppDelegate.swift
//  UnsplashAppTask
//
//  Created by Aliaksandr Dvoineu on 12.10.23.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    private let connectivityService = ConnectivityService()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        connectivityService.startObservingConnectivity()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {}
}
