//
//  QuizListApp.swift
//  QuizListApp
//
//  Created by Alexander v. Below on 22.07.21.
//  Copyright © 2021 Alexander v. Below. All rights reserved.
//

import SwiftUI
import WatchConnectivity

@main
struct QuizListApp: App {
    let sessionDelegate = WatchConnectionDelegate()
    
    init() {
        if WCSession.isSupported() { // It always is, on the watch
            let session = WCSession.default
            session.delegate = sessionDelegate
            session.activate()
        }
    }
    var body: some Scene {
        WindowGroup {
            WatchView()
        }
    }
}
