//
//  AppDelegate.swift
//  FacebokFeedbackApp
//
//  Created by Adrian Kremski on 25/10/2019.
//  Copyright © 2019 Adrian Kremski. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.rootViewController = FacebookTabBarController()
        
        UINavigationBar.appearance().barTintColor = UIColor(red: 51/255, green: 90/255, blue: 149/255, alpha: 1)
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        application.statusBarStyle = .lightContent
        UITabBar.appearance().tintColor = UIColor.rgb(red: 70, green: 146, blue: 250)
        return true
    }

}

