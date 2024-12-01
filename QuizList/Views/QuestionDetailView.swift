//
//  QuestionDetailView.swift
//  QuizList
//
//  Created by Alexander von Below on 01.12.24.
//  Copyright © 2024 Alexander v. Below. All rights reserved.
//

import SwiftUI

struct QuizModel: Equatable {
    var text: String?
    var image: UIImage?

    static func ==(lhs: QuizModel, rhs: QuizModel) -> Bool {
        return lhs.text == rhs.text && lhs.image == rhs.image
    }
}


struct QuestionDetailView: View {
    var item: QuizModel
    var body: some View {
        ZStack {
            if let image = item.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            }
            if let question = item.text {
                Text(question)
                    .font(.title)
                    .frame(maxWidth: .infinity)
            }
        }
    }
}

#Preview {
    let image = UIImage(named: "The_red_panda_(Ailurus_fulgens)_1")
    QuestionDetailView(item: QuizModel(text: "Rule of Acquisition 1"))
    QuestionDetailView(item: QuizModel(image: image))
        
}
