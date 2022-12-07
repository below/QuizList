//
//  HelpView.swift
//  QuizList
//
//  Created by Alexander v. Below on 22.07.21.
//  Copyright © 2021 Alexander v. Below. All rights reserved.
//

import SwiftUI

struct HelpView: View {
    private var list: QuizList
    init(list: QuizList) {
        self.list = list
    }

    var body: some View {
        VStack(spacing: 10) {
            Text("Help").font(.largeTitle)
            Spacer()

            List(list.items, id: \.number) { element in
                Text(element.text)
            }
        }
    }
}

#if os(iOS)
class HelpViewHostingController: UIHostingController<HelpView>, ListController {
    let helpView = HelpView(list: QuizList())

    var list: QuizList! {
        didSet {
            self.rootView = HelpView(list: list)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder, rootView: HelpView(list: QuizList()))
    }
}
#endif

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        HelpView(list: QuizList())
    }
}
