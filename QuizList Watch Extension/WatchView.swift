//
//  WatchView.swift
//  WatchView
//
//  Created by Alexander v. Below on 22.07.21.
//  Copyright © 2021 None. All rights reserved.
//

import SwiftUI

struct WatchView: View {
    var body: some View {
        TabView {
            ScrollView {
                QuestionView(list: QuizList())
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
