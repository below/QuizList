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
        return .result(value: "A list")
    }
  
    static var openAppWhenRun: Bool = false
}
