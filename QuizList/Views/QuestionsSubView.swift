//
//  QuestionsSubView.swift
//  QuizList
//
//  Created by Alexander von Below on 01.12.24.
//  Copyright © 2024 Alexander v. Below. All rights reserved.
//

import SwiftUI

struct QuestionsSubView: View {
    var question: QuizModel
    var answers: [String]
    var correctAnswer: Int? = nil
    var action: (Int) -> Void = {_ in }
    
#if os(watchOS)
    let watchOS = true
#else
    let watchOS = false
#endif
    
    var body: some View {
        List {
            Section () {
                QuestionDetailView(item: question)
            }
            ForEach(0..<answers.count, id: \.self) { i in
                let answer = answers[i]
                Button(action: {
                    action(i)
                }, label: {
                    let text = Text(answer)
                        .font(watchOS ? .caption : .title)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding()
                    
                    if let correctAnswer, i == correctAnswer {
                        text.foregroundColor(.red)
                            .font(.title.bold())
                    } else {
                        text
                    }
                }).frame(maxWidth: .infinity)
            }
        }
        .multilineTextAlignment(.center)
    }
}

#Preview {
    QuestionsSubView(question: QuizModel(text: "Rule of Acquisition 1"),
        answers: [
        "Once you have their money, you never give it back.",
        "Greed is eternal.",
        "Never place friendship above profit.",
        "War is good for business."]) { answer in
            print ("Selected Answer \(answer)")
        }
}

#Preview {
    let image = UIImage(named: "The_red_panda_(Ailurus_fulgens)_1")

    QuestionsSubView(question: QuizModel(image: image),
        answers: [
        "Panda",
        "Red Panda",
        "Fox",
        "Bear"], correctAnswer: 0)
}
