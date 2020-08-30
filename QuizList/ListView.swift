//
//  ListView.swift
//  QuizList
//
//  Created by Alexander v. Below on 27.08.20.
//  Copyright © 2020 None. All rights reserved.
//

import SwiftUI

struct ListView: View {
    var list: QuizList
    @State var quizList = [QuizListElement]()
    @State var editMode: EditMode = .active
    @State var showShuffleButton = false

    internal func shuffledList () -> [QuizListElement]{
        var mutableList = [QuizListElement]()
        for element in self.list {
            mutableList.append(element)
        }
        return mutableList.shuffled()
    }

    func reshuffle() {
        quizList = shuffledList()
        self.editMode = .active
    }

    init(list: QuizList) {
        self.list = list

        _quizList = State(initialValue: shuffledList())
    }

    struct MyList: View {
        let quizList: [QuizListElement]
        let action: ((IndexSet, Int) -> Void)?
        @Binding var editMode: EditMode

        var body: some View {
            List {
                ForEach (0..<quizList.count) { i in
                    Text(quizList[i].text)
                }
                .onMove(perform: action)
            }
            .environment(\.editMode, $editMode)
        }
    }

    var body: some View {
        NavigationView {
            let myList = MyList(quizList: quizList, action: move, editMode: $editMode)
            if (showShuffleButton) {
                myList.navigationBarItems(trailing:
                                            Button("Reshuffle", action: {
                                                reshuffle()
                                            })
                    )
            } else {
                myList
            }
        }
    }

    var allInPlace: Bool {
        return quizList == list
    }

    func move(from indices: IndexSet, to newOffset: Int) {
        quizList.move(fromOffsets: indices, toOffset: newOffset)
        if allInPlace {
            editMode = .inactive
            showShuffleButton = true
        }
    }
}

class ListViewHostingController: UIHostingController<ListView>, ListController {
    let questionView = QuestionView(list: QuizList())

    var list: QuizList! {
        didSet {
//            self.rootView = ListView(list: list)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder, rootView: ListView(list: QuizList()))
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView(list: QuizList())
    }
}
