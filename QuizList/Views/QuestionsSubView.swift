//
//  QuestionsSubView.swift
//  QuizList
//
//  Created by Alexander von Below on 01.12.24.
//  Copyright © 2024 Alexander v. Below. All rights reserved.
//

import SwiftUI

struct QuestionsSubView: View {
    var question: String
    var answers: [String]
#if os(watchOS)
    let watchOS = true
#else
    let watchOS = false
#endif
    
    var body: some View {
        Form {
            Section(question) {
                ForEach(answers, id: \.self) { answer in
                    Button(action: {}, label: {
                        let text = Text(answer)
                            .font(watchOS ? .caption : .title)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding()
                        
                        text
                    }).frame(maxWidth: .infinity)
                }
            }
        }
        .font(.system(.title))
        .multilineTextAlignment(.center)
    }
}

#Preview {
    QuestionsSubView(question: "Item #1", answers: [
        "Once you have their money, you never give it back.",
        "Greed is eternal.",
        "Never place friendship above profit.",
        "War is good for business."])
}
