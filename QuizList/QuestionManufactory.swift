//
//  QuestionManufactory.swift
//  QuizList
//
//  Created by Alexander v. Below on 11.06.19.
//  Copyright © 2019 None. All rights reserved.
//

import Foundation

typealias AllCorrectClosure = () -> Void

class QuestionManufactory {
    
    enum QuestionError : Error {
        case invalidParameters
    }
    
    var list: QuizList
    var allCorrect: AllCorrectClosure?
    private var currentIndex = 0
    private var correctItems = [Int]()
    
    public var inOrder = true {
        didSet {
            currentIndex = 0
        }
    }

    init(list : QuizList, allCorrect: AllCorrectClosure? = nil) {
        self.list = list
        self.allCorrect = allCorrect
    }
    
    func randomIndex () -> Int {
        return Int.random(in: 0 ... list.items.count - 1)
    }
    
    func nextQuestion () -> Int {
        
        if correctItems.count == list.items.count {
            correctItems.removeAll()
            inOrder = !inOrder
            if let allCorrect = allCorrect {
                allCorrect()
            }
        }

        if inOrder {
            defer {currentIndex = currentIndex + 1; if currentIndex >= list.items.count { currentIndex = 0 }}
            return currentIndex
        }
        else {
            var newIndex: Int!
            repeat {
                newIndex = randomIndex()
            } while correctItems.contains(newIndex)
            return newIndex
        }
    }
    
    typealias Answers = (correctAnswer: Int, answers: [String])
    func answers (question: Int, number: Int) throws -> Answers {
        
        guard number <= list.items.count-1 else {
            throw QuestionError.invalidParameters
        }
        
   // https://twitter.com/smith47777/status/1554850985318703110
        // Maybe later …
        let range = 0 ..< number
        var usedAnswers = [list.items[question]]
        
        let correctAnswerNumber = Int.random(in: range)
        var resultAnswers = [String]()
        for i in range {
            var answerNumber: Int!
            var answer: QuizListElement!
            if i == correctAnswerNumber {
                answer = list.items[question]
            } else {
                repeat {
                    answerNumber = randomIndex()
                    answer = list.items[answerNumber]
                } while usedAnswers.contains(answer)
                usedAnswers.append(answer)
            }
            resultAnswers.append(answer.text)
        }
        return (correctAnswerNumber, resultAnswers)
    }
    
    func appendCorrectAnswer(_ new: Int) {
        self.correctItems.append(new)
    }
}
