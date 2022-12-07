//
//  Intents.swift
//  QuizList
//
//  Created by Alexander von Below on 07.12.22.
//  Copyright © 2022 Alexander v. Below. All rights reserved.
//

import Foundation
import AppIntents

@available(iOS 16, *)
struct ListAllItems: AppIntent {
    static var title: LocalizedStringResource = "List all Items"

    @MainActor
    func perform() async throws -> some IntentResult {
        // I should put this into a convenience function
        var list: QuizList = QuizList()
        if let sharedList = try? QuizList(firstAt: ContainerURL()) {
            list = sharedList
        }
        
        let resultString = list.items.reduce("") { partialResult, element in
            partialResult + "\(element.number)" + " " + element.text + "\n"
        }
        
        return .result(value: resultString)
    }
  
    static var openAppWhenRun: Bool = false
}
