//
//  PhoneConnectionDelegate.swift
//  QuizList
//
//  Created by Alexander von Below on 23.11.22.
//  Copyright © 2022 Alexander v. Below. All rights reserved.
//

import WatchConnectivity

class PhoneConnectionDelegate: NSObject, WCSessionDelegate {
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
            
            guard session.isWatchAppInstalled else {
                NSLog("No watch App installed")
                return
            }
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
    }
    
    func session(_ session: WCSession,
                 didFinish fileTransfer: WCSessionFileTransfer,
                 error: Error?) {
        if let error = error {
            NSLog("File Transfer failed: \(error.localizedDescription)")
        } else {
            let name = fileTransfer.file.fileURL.lastPathComponent
            NSLog("File successfully transferred: \(name)")
        }
        do {
            try FileManager.default.removeItem(at: fileTransfer.file.fileURL)
        } catch {
            print ("Removing the file at \(String(describing: fileTransfer)) failed!")
        }
    }
}
