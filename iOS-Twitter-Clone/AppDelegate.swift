//
//  AppDelegate.swift
//  iOS-Twitter-Automation
//
//  Created by ahmed on 2/1/19.
//  Copyright © 2019 com.ahmed. All rights reserved.
//

import UIKit
import Firebase
import TwitterKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()

        TWTRTwitter.sharedInstance().start(withConsumerKey: "", consumerSecret: "")
        
        window =  UIWindow()
        window?.makeKeyAndVisible()
        window?.rootViewController = RootViewController()
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return TWTRTwitter.sharedInstance().application(app, open: url, options: options)
    }


}


