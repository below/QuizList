//
//  QuestionView.swift
//  QuizList
//
//  Created by Alexander v. Below on 26.08.20.
//  Copyright © 2020 None. All rights reserved.
//

import SwiftUI

extension Text {
    public func highlight(_ highlight: Bool) -> some View {
        if highlight {
            return self.foregroundColor(.red)
        } else {
            return self
        }
    }
}

struct QuestionView: View {
    private var list: QuizList
    private var quizFactory: QuestionManufactory
    @State var item = 0
    @State var showCorrectAnswer: Int?

    init(list: QuizList, item: Int? = nil) {
        self.list = list
        self.quizFactory = QuestionManufactory(list: list)
        if let item = item {
            self.item = item
        } else {
            self.item = quizFactory.nextQuestion()
        }
    }

    var body: some View {
        VStack(spacing: 10) {
            Text("Item # \(list[item].number)").bold()

            let answerSet = try! self.quizFactory.answers(question: self.item, number: 4)

            ForEach(0..<answerSet.answers.count) { i in
                Button(action: {
                    if i == answerSet.correctAnswer {
                        quizFactory.appendCorrectAnswer(i)
                        self.item = self.quizFactory.nextQuestion()
                    } else {
                        self.showCorrectAnswer = answerSet.correctAnswer
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            self.showCorrectAnswer = nil
                            self.item = self.quizFactory.nextQuestion()
                        }
                    }
                }, label: {
                    Text(answerSet.answers[i]).highlight(i == showCorrectAnswer)
                }).frame(maxWidth: .infinity)

            }
        }.font(.system(size: 32)).multilineTextAlignment(.center)
    }
}

class QuestionViewHostingController: UIHostingController<QuestionView> {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder, rootView: QuestionView(list: QuizList()))
    }
}

struct QuestionView_Previews: PreviewProvider {
    static var previews: some View {
        QuestionView(list: QuizList())
    }
}
