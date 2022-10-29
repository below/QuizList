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
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        // https://developer.apple.com/documentation/uikit/uiapplicationdelegate/1623112-application
        
        let fileName = url.lastPathComponent
        let targetURL = FileManager.default.documentsDirURL
            .appendingPathComponent(fileName)
        do {
            try FileManager.default.copyItem(
                at: url,
                to: targetURL)
        } catch {
            let nsError = error as NSError
            if nsError.domain == NSPOSIXErrorDomain, nsError.code == 17 {
                print("File '\(fileName)' exists")
            }
            print ("Unable to copy: \(error)")
            return false
        }
        // We do not use files in-place
        do {
            try FileManager.default.removeItem(at: url)
        } catch {
            print ("Unable to delete file '\(fileName)'")
        }
        return true
    }
}

