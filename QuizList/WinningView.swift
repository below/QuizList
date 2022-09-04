//
//  WinningView.swift
//  QuizList
//
//  Created by Alexander von Below on 07.08.22.
//  Copyright © 2022 None. All rights reserved.
//

import SwiftUI

struct WinningView: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        Button("Great!") {
            dismiss()
        }
    }
}

struct WinningView_Previews: PreviewProvider {
    static var previews: some View {
        WinningView()
    }
}
