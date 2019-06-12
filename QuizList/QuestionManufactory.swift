//
//  QuestionManufactory.swift
//  QuizList
//
//  Created by Alexander v. Below on 11.06.19.
//  Copyright © 2019 None. All rights reserved.
//

import Foundation

class QuestionManufactory {
    
    enum QuestionError : Error {
        case invalidParameters
    }
    
    var list: QuizList
    private var currentIndex = 0
    private var correctItems = [Int]()
    
    public var inOrder = true {
        didSet {
            currentIndex = 0
        }
    }

    init(list : QuizList) {
        self.list = list
    }
    
    func randomIndex () -> Int {
        return Int.random(in: 0 ... list.count - 1)
    }
    
    func nextQuestion () -> Int {
        
        if correctItems.count == list.count {
            correctItems.removeAll()
            inOrder = !inOrder
        }

        if inOrder {
            defer {currentIndex = currentIndex + 1; if currentIndex >= list.count { currentIndex = 0 }}
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
        
        guard number <= list.count-1 else {
            throw QuestionError.invalidParameters
        }
        
        let range = 0 ..< number
        var usedAnswers = [question]
        let correctAnswerNumber = Int.random(in: range)
        var resultAnswers = [String]()
        for i in range {
            var answerNumber: Int!
            if i == correctAnswerNumber {
                answerNumber = question
            } else {
                repeat {
                    answerNumber = randomIndex()
                } while usedAnswers.contains(answerNumber)
                usedAnswers.append(answerNumber)
            }
            let answer = list[answerNumber]
            resultAnswers.append(answer.text)
        }
        return (correctAnswerNumber, resultAnswers)
    }
    
    func appendCorrectAnswer(_ new: Int) {
        self.correctItems.append(new)
    }
}
