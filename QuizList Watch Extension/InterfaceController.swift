//
//  InterfaceController.swift
//  QuizList Watch Extension
//
//  Created by Alexander v. Below on 11.06.19.
//  Copyright © 2019 None. All rights reserved.
//

import WatchKit
import Foundation

class InterfaceController: WKInterfaceController {

    @IBOutlet weak var label: WKInterfaceLabel!
    @IBOutlet weak var table: WKInterfaceTable!
    
    var list: QuizList!
    var quizFactory: QuestionManufactory!
    var questionNumber: Int!
    var correctAnswerNumber: Int!

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        do {
            if let url = Bundle.main.url(forResource: "QuizList", withExtension: "json") {
                
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                list = try decoder.decode(QuizList.self, from: data)
            }
        }
        catch {
        }
        if list == nil {
            list = QuizList()
        }

        quizFactory = QuestionManufactory(list: list)
        setupQuiz()
    }
    
    func setupQuiz () {
        
        questionNumber = quizFactory.nextQuestion()
        let format = NSLocalizedString("Item #%d?", comment: "")
        label.setText(String.init(format: format, questionNumber + 1))
        

        self.table.setRowTypes(["QuizRowType"])
        let numberOfRows = 4
        self.table.setNumberOfRows(numberOfRows, withRowType: "QuizRowType")
        var answers: QuestionManufactory.Answers!
        do {
            answers = try quizFactory.answers(question: questionNumber, number: numberOfRows)
            correctAnswerNumber = answers.correctAnswer
        } catch {
            return
        }
        
        for i in 0 ..< self.table.numberOfRows {
            if let controller = self.table.rowController(at: i) as? QuizRowType {
                controller.label.setTextColor(.white)
                controller.label.setText(answers.answers[i])
            }
        }
    }
    
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        if rowIndex == correctAnswerNumber {
            if let controller = self.table.rowController(at: rowIndex) as? QuizRowType {
                
                let text = list.items[questionNumber].text
                let font = UIFont.preferredFont(forTextStyle: .headline)
                
                let attrStr = NSAttributedString(string: text, attributes: [NSAttributedString.Key.font: font])
                controller.label.setAttributedText(attrStr)
                self.quizFactory.appendCorrectAnswer(questionNumber)
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: { self.setupQuiz()
        })

    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
