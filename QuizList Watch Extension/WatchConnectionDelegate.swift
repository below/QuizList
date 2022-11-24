//
//  WatchConnectionDelegate.swift
//  QuizListWidgetExtension
//
//  Created by Alexander von Below on 23.11.22.
//  Copyright © 2022 None. All rights reserved.
//

import WatchConnectivity

class WatchConnectionDelegate: NSObject, WCSessionDelegate {
    func session(
        _ session: WCSession,
        activationDidCompleteWith
        activationState: WCSessionActivationState,
        error: Error?) {
            
            guard error == nil else {
                NSLog("Error! \(String(describing:error?.localizedDescription))")
                return
            }
            guard activationState == .activated else {
                NSLog("Session not activated!")
                return
            }
        }
    
    func session(_ session: WCSession,
                 didReceive file: WCSessionFile) {
        
        let name = file.fileURL.deletingPathExtension().lastPathComponent
        let destURL: URL
        if #available(watchOS 9.0, *) {
            destURL = ContainerURL()
                .appending(component: name)
                .appendingPathExtension(Constants.FileExtenstion.rawValue)
        } else {
            let destPath = ContainerURL().path + "/" + name + "." + Constants.FileExtenstion.rawValue
            destURL = URL(fileURLWithPath: destPath)
        }
        
        do {
            try decompress(url: file.fileURL,
                           to: destURL)
        } catch {
            print ("Decompression failed: \(error)")
        }
    }
}
