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
    var quizFactory: QuestionManufactory!
    var correctAnswerNumber = 0
    var questionNumber = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        quizFactory = QuestionManufactory(list: list)
        self.setupQuiz()
    }
    
    @IBAction func setupQuiz () {
        guard list != nil else {
            return
        }

        questionNumber = quizFactory.nextQuestion()
        
        let format = NSLocalizedString("Item #%d?", comment: "")
        questionLabel.text = String.init(format: format, questionNumber + 1)
        
        do {
        let answerSet = try quizFactory.answers(question: questionNumber, number: 4)
            correctAnswerNumber = answerSet.correctAnswer
            for i in 1 ... 4 {
                guard let button = view.viewWithTag(i) as? UIButton else {
                    return
                }
                guard i <= answerSet.answers.count else {
                    button.isHidden = true
                    return
                }
                button.titleLabel?.numberOfLines = 0
                button.titleLabel?.lineBreakMode = .byWordWrapping
                button.tintColor = self.view.tintColor
                button.isHidden = false
                
                let answer = answerSet.answers[i-1]
                button.setTitle(answer, for: .normal)
            }
        }
        catch {
            return
        }
        

    }

    @IBAction func attemptAnswer(_ sender: UIButton) {
        if correctAnswerNumber == sender.tag - 1 {
            quizFactory.appendCorrectAnswer(correctAnswerNumber)
        } else {
            guard let button = view.viewWithTag(correctAnswerNumber + 1) as? UIButton else {
                return
            }
            button.tintColor = .red
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: { self.setupQuiz()
        }
        )
    }
}

