//
//  QuestionView.swift
//  QuizList
//
//  Created by Alexander v. Below on 26.08.20.
//  Copyright © 2020 None. All rights reserved.
//

import SwiftUI

// https://twitter.com/teilweise/status/1567240328305942528

let RewardNotificationName = Notification.Name.init("allCorrect")

struct QuestionView: View {
    private var list: QuizList
    private var quizFactory: QuestionManufactory
    @State var item = 0
    @State var showCorrectAnswer: Bool = false
    @State var answerSet: QuestionManufactory.Answers!
    @State private var showReward = false
    var watchOS = false
    // Needs to be moved to subview

    init(list: QuizList, item: Int? = nil) {
        #if (watchOS)
        watchOS = true
        #endif
        self.list = list
        self.quizFactory = QuestionManufactory(list: list) {
            NotificationCenter.default.post(
                name: RewardNotificationName,
                object: nil)
        }
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
            Text("Item # \(list.items[item].number)").bold()
            Spacer()

            ForEach(0..<answerSet.answers.count, id: \.self) { i in
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
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            self.nextQuestion()
                        }
                    }
                }, label: {
                    let text = Text(answerText)
                        .font(watchOS ? .title : .caption)
                        .lineLimit(nil)
                        .padding()

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
        .onAppear {
            NotificationCenter.default.addObserver(
                forName: RewardNotificationName,
                object: nil,
                queue: .main) { note in
                    self.showReward = true
                }
        }
        .sheet(isPresented: $showReward, onDismiss: {}) {

            let image: UIImage? = list.randomPicture
            WinningView(image: image)
            
        }
    }
}

#if os(iOS)
class QuestionViewHostingController: UIHostingController<QuestionView>, ListController {

    var list: QuizList! {
        didSet {
            self.rootView = QuestionView(list: list)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder, rootView: QuestionView(list: QuizList()))
    }
}
#endif

struct QuestionView_Previews: PreviewProvider {
    static var previews: some View {
        QuestionView(list: QuizList())
    }
}
