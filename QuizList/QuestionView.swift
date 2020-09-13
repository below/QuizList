//
//  QuestionView.swift
//  QuizList
//
//  Created by Alexander v. Below on 26.08.20.
//  Copyright © 2020 None. All rights reserved.
//

import SwiftUI

struct QuestionView: View {
    private var list: QuizList
    private var quizFactory: QuestionManufactory
    @State var item = 0
    @State var showCorrectAnswer: Bool = false
    @State var answerSet: QuestionManufactory.Answers!

    init(list: QuizList, item: Int? = nil) {
        self.list = list
        self.quizFactory = QuestionManufactory(list: list)
        if let item = item {
            self.item = item
        } else {
            self.item = quizFactory.nextQuestion()
        }
        do {
            let set = try self.quizFactory.answers(question: self.item, number: 4)
            _answerSet = State(initialValue: set)
        } catch {
            debugPrint("Unable to create answer set")
        }
    }

    func nextQuestion() {
        self.showCorrectAnswer = false
        self.item = self.quizFactory.nextQuestion()
        self.answerSet = try! quizFactory.answers(question: self.item, number: 4)
    }

    var body: some View {
        VStack(spacing: 10) {
            Text("Item # \(list[item].number)").bold()
            Spacer()

            ForEach(0..<answerSet.answers.count) { i in
                let answerText = answerSet.answers[i]
                Button(action: {
                    // Don't like this …
                    // The idea is that there may be more than one
                    // item with the same text

                    // Update: There should be only one correct answer
                    if i == answerSet.correctAnswer || answerText == answerSet.answers[answerSet.correctAnswer] {
                        quizFactory.appendCorrectAnswer(self.item)
                        self.nextQuestion()
                    } else {
                        self.showCorrectAnswer = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            self.nextQuestion()
                        }
                    }
                }, label: {
                    let text = Text(answerText)

                    if showCorrectAnswer, i == answerSet.correctAnswer {
                        text.foregroundColor(.red)
                    } else {
                        text
                    }
                }).frame(maxWidth: .infinity)

            }
            Spacer()
        }
        .font(.system(.title))
        .multilineTextAlignment(.center)
    }
}

class QuestionViewHostingController: UIHostingController<QuestionView>, ListController {
    let questionView = QuestionView(list: QuizList())

    var list: QuizList! {
        didSet {
            self.rootView = QuestionView(list: list)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder, rootView: QuestionView(list: QuizList()))
    }
}

struct QuestionView_Previews: PreviewProvider {
    static var previews: some View {
        QuestionView(list: QuizList())
    }
}
