//
//  AppDelegate.swift
//  QuizList
//
//  Created by Alexander v. Below on 09.06.19.
//  Copyright © 2019 None. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }
    
    func application(
        _ application: UIApplication,
        open url: URL, sourceApplication: String?,
        annotation: Any) -> Bool {
        print ("Deprecated Method called")
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        // https://developer.apple.com/documentation/uikit/uiapplicationdelegate/1623112-application
        print("open: options:")
        return true
    }
}

