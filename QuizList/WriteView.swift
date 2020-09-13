//
//  WriteView.swift
//  QuizList
//
//  Created by Alexander v. Below on 30.08.20.
//  Copyright © 2020 None. All rights reserved.
//

import SwiftUI

extension String {
    var sanitized : String {
        get {
            let charset = CharacterSet.alphanumerics.inverted
            return self.components(separatedBy: charset).joined().lowercased()
        }
    }
}

enum AnswerState {
    case correct
    case wrong
}

struct CorrectAnswerView: View {
    var answerState: AnswerState?
    var text: String

    var body: some View {
        if answerState == nil {
            return Text("")
        } else {
            return Text(text).foregroundColor(answerState == .wrong ? .red:.black)
        }
    }
}

struct WriteView: View {
    var list: QuizList
    private let quizFactory: QuestionManufactory
    @State var answer: String = ""
    @State var showAnswer: AnswerState?
    @State var currentQuestion = 0

    init(list: QuizList) {
        self.list = list
        self.quizFactory = QuestionManufactory(list: list)
        currentQuestion = quizFactory.nextQuestion()
    }

    func checkAnswer() {
        if answer.sanitized == list[currentQuestion].text.sanitized {
            showAnswer = .correct
            quizFactory.appendCorrectAnswer(currentQuestion)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                answer = ""
                showAnswer = nil
                currentQuestion = quizFactory.nextQuestion()
            }
        } else {
            showAnswer = .wrong
        }
    }

    var body: some View {
        VStack {
            Text("Item \(currentQuestion + 1)").font(.largeTitle)
            TextField("Enter Answer", text: $answer) { (changed) in
                debugPrint("Foo")
            } onCommit: {
                checkAnswer()
            }.multilineTextAlignment(.center)

            Button("Try Me") {
                checkAnswer()
            }.padding()
            CorrectAnswerView(answerState: showAnswer, text: list[currentQuestion].text)
            Spacer()
        }
    }
}

class WriteViewHostingController: UIHostingController<WriteView>, ListController {

    let questionView = WriteView(list: QuizList())

    var list: QuizList! {
        didSet {
            self.rootView = WriteView(list: list)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder, rootView: WriteView(list: QuizList()))
    }
}

struct WriteView_Previews: PreviewProvider {
    static var previews: some View {
        WriteView(list: QuizList())
    }
}
