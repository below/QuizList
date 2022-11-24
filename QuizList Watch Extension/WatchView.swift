//
//  WatchView.swift
//  WatchView
//
//  Created by Alexander v. Below on 22.07.21.
//  Copyright © 2021 None. All rights reserved.
//

import SwiftUI

struct WatchView: View {
    var list: QuizList!
    init() {
        if let quiz = try? QuizList(firstAt: ContainerURL()) {
            self.list = quiz
        } else {
            self.list = QuizList()
        }
    }
    
    var body: some View {
        TabView {
            ScrollView {
                QuestionView(list: list)
            }
            .tabItem {
                Text("Quiz")
            }
            HelpView(list: QuizList())
                .tabItem {
                    Text("Help")
                }
        }
    }
}

struct WatchView_Previews: PreviewProvider {
    static var previews: some View {
        WatchView()
    }
}
