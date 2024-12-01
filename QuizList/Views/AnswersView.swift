//
//  AnswersView.swift
//  QuizList
//
//  Created by Alexander von Below on 01.12.24.
//  Copyright © 2024 Alexander v. Below. All rights reserved.
//

import SwiftUI

struct AnswersView: View {
    var answers: [String]
#if os(watchOS)
    let watchOS = true
#else
    let watchOS = false
#endif
    
    var body: some View {
            List {
                Section () {
                    Text("Answers")
                        .font(.title)
                }
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
            .font(.system(.title))
            .multilineTextAlignment(.center)
        }
}

#Preview {
    AnswersView(
        answers: [
        "Once you have their money, you never give it back.",
        "Greed is eternal.",
        "Never place friendship above profit.",
        "War is good for business."])
}
