//
//  WriteView.swift
//  QuizList
//
//  Created by Alexander v. Below on 30.08.20.
//  Copyright © 2020 Alexander v. Below. All rights reserved.
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
    @State private var showReward = false
    @FocusState private var answerIsFocussed: Bool

    init(list: QuizList) {
        self.list = list
        self.quizFactory = QuestionManufactory(list: list) {
            NotificationCenter.default.post(
                name: RewardNotificationName,
                object: nil)
        }
        currentQuestion = quizFactory.nextQuestion()
    }

    func checkAnswer() {
        if answer.sanitized == list.items[currentQuestion].text.sanitized {
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
            HStack {
                Text("Item \(currentQuestion + 1)").font(.largeTitle)
            }
            TextField("Enter Answer", text: $answer) { (changed) in
                debugPrint("Foo")
            } onCommit: {
                answerIsFocussed = false
                checkAnswer()
            }
            .multilineTextAlignment(.center)
            .focused($answerIsFocussed)
            Button("Try Me") {
                checkAnswer()
            }.padding()
            CorrectAnswerView(answerState: showAnswer, text: list.items[currentQuestion].text)
            Spacer()
        }
        .onTapGesture {
            answerIsFocussed = false
        }
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
