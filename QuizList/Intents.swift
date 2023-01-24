//
//  Intents.swift
//  QuizList
//
//  Created by Alexander von Below on 07.12.22.
//  Copyright © 2022 Alexander v. Below. All rights reserved.
//


/// Dokumentation:
/// https://developer.apple.com/documentation/appintents/providing-your-app-s-capabilities-to-system-services
/// https://developer.apple.com/documentation/sirikit/offering_actions_in_the_shortcuts_app

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

//@available(iOS 16, *)
//enum QuizIntentError: Swift.Error, CustomLocalizedStringResourceConvertible {
//    case general
//    case message(_ message: String)
//
//    var localizedStringResource: LocalizedStringResource {
//        switch self {
//        case let .message(message): return "Error: \(message)"
//        case .general: return "My general error"
//        }
//    }
//}
//
//@available(iOS 16, *)
//struct QuizAnItem: AppIntent {
////    @Parameter(title: "Number")
////    var itemNumber: Int?
//    @Parameter(title: "Answer")
//    var answer: String?
//    
//    static var title: LocalizedStringResource = "Quiz an Item"
//
//    @MainActor
//    func perform() async throws -> some IntentResult {
//        // I should put this into a convenience function
//        var list: QuizList = QuizList()
//        if let sharedList = try? QuizList(firstAt: ContainerURL()) {
//            list = sharedList
//        }
//        
//        var items = list.items
//        
//        guard let quizItem = items.randomElement() else {
//            throw QuizIntentError.message("No Item found")
//        }
//        
//        answer = quizItem.text
//        
//        items = items.filter{
//            $0.text != quizItem.text
//        }
//        
//        try $answer.requestDisambiguation(among: ["a", "b", "c", "d"])
//            
//        return .result()
//    }
//  
//    static var openAppWhenRun: Bool = false
//}
