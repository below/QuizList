//
//  WriteController.swift
//  QuizList
//
//  Created by Alexander v. Below on 12.06.19.
//  Copyright © 2019 None. All rights reserved.
//

import UIKit
import QuartzCore

extension String {
    var sanitized : String {
        get {
            let charset = CharacterSet.alphanumerics.inverted
            return self.components(separatedBy: charset).joined()
        }
    }
}

class WriteController: UIViewController, ListController, UITextViewDelegate {
    var list: QuizList!
    var quizFactory: QuestionManufactory!
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var questionField: UITextView!
    @IBOutlet weak var answerField: UITextView!
    @IBOutlet weak var button: UIButton!

    var questionNumber: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        questionField.layer.cornerRadius = 8
        questionField.layer.masksToBounds = true
        questionField.layer.borderColor = UIColor.gray.cgColor
        questionField.layer.borderWidth = 1
        questionField.delegate = self
        questionField.returnKeyType = .done
        quizFactory = QuestionManufactory(list: list)
        setupQuiz()
    }

    func setupQuiz () {
        questionNumber = quizFactory.nextQuestion()
        let format = NSLocalizedString("Item #%d?", comment: "")
        questionLabel.text = String.init(format: format, questionNumber + 1)
        questionField.text = ""
        answerField.text = ""
        button.isEnabled = true
        questionField.becomeFirstResponder()
    }
    
    @IBAction func checkAnswer() {
        button.isEnabled = false
        let answer = questionField.text
        let sanitizedAnswer = answer?.sanitized
        
        let correctAnswer = list[questionNumber].text
        let sanitizedCorrectAnswer = correctAnswer.sanitized
        
        var color: UIColor!
        if sanitizedCorrectAnswer.lowercased() == sanitizedAnswer?.lowercased() {
            color = .green
            if answer == correctAnswer {
                color = .black
            }
            quizFactory.appendCorrectAnswer(questionNumber)
        } else {
            color = .red
        }
        let attrS = NSAttributedString(string: correctAnswer, attributes: [NSAttributedString.Key.foregroundColor: color!])
        answerField.attributedText = attrS
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: { self.setupQuiz()
        }
        )
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let resultRange = text.rangeOfCharacter(from: CharacterSet.newlines, options: .backwards)
        if text.count == 1, !(resultRange?.isEmpty ?? true) {
            textView.resignFirstResponder()
            return false
        }
        else {
            return true
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        self.checkAnswer()
    }
}
