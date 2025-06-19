//
//  MainTabView.swift
//  QuizList
//
//  Created by Alexander von Below on 19.06.25.
//  Copyright © 2025 Alexander v. Below. All rights reserved.
//

import SwiftUI

struct MainTabView: View {
    let list: QuizList

    var body: some View {
        TabView {
            Tab("Quiz", systemImage: "questionmark.circle") {
                QuestionView(list: list)
            }
            Tab("List", systemImage: "list.number") {
                ListView(list: list)
            }
            Tab("Write", systemImage: "pencil.circle") {
                WriteView(list: list)
            }
            Tab("Help", systemImage: "exclamationmark.circle") {
                HelpView(list: list)
            }
            Tab("Settings", systemImage: "gear") {
                SettingsView()
            }
        }
    }
}

#Preview {
    MainTabView(list: QuizList())
}
