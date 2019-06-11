//
//  ViewController.swift
//  QuizList
//
//  Created by Alexander v. Below on 09.06.19.
//  Copyright © 2019 None. All rights reserved.
//

import UIKit

class ViewController: UIViewController, ListController {

    @IBOutlet weak var questionLabel: UILabel!

    var list: QuizList!
    var correctAnswerNumber = 0
    var questionNumber = 0
    var correctItems = [Int]()
    var inOrder = false
    var currentIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupQuiz()
    }
    
    func randomIndex () -> Int {
        return Int.random(in: 0 ... list.count - 1)
    }

    func nextQuestion () -> Int {
        if inOrder {
            defer {currentIndex = currentIndex + 1}
            return currentIndex
        }
        else {
            var newIndex: Int!
            repeat {
                newIndex = randomIndex()
            } while correctItems.contains(questionNumber)
            return newIndex
        }
    }
    
    @IBAction func setupQuiz () {
        guard list != nil else {
            return
        }
        if correctItems.count == list.count {
            correctItems.removeAll()
            currentIndex = 0
            inOrder = !inOrder
        }
        
        questionNumber = nextQuestion()
        
        let format = NSLocalizedString("Item #%d?", comment: "")
        questionLabel.text = String.init(format: format, questionNumber + 1)
        
        correctAnswerNumber = Int.random(in: 1 ... min(4, list.count))
        
        var usedAnswers = [questionNumber]
        for i in 1 ... 4 {
            guard let button = view.viewWithTag(i) as? UIButton else {
                return
            }
            guard i < list.count else {
                button.isHidden = true
                return
            }
            button.titleLabel?.numberOfLines = 0
            button.titleLabel?.lineBreakMode = .byWordWrapping
            button.tintColor = self.view.tintColor
            button.isHidden = false

            var answerNumber : Int!
            if i == correctAnswerNumber {
                answerNumber = questionNumber
            } else {
                repeat {
                    answerNumber = randomIndex()
                } while usedAnswers.contains(answerNumber)
                usedAnswers.append(answerNumber)
            }
            let answer = list[answerNumber]
            button.setTitle(answer.text, for: .normal)
        }
    }

    @IBAction func attemptAnswer(_ sender: UIButton) {
        if correctAnswerNumber == sender.tag {
            correctItems.append(questionNumber)
        } else {
            guard let button = view.viewWithTag(correctAnswerNumber) as? UIButton else {
                return
            }
            button.tintColor = .red
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: { self.setupQuiz()
        }
        )
    }
}

