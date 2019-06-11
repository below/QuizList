//
//  QuizList.swift
//  QuizList
//
//  Created by Alexander v. Below on 09.06.19.
//  Copyright © 2019 None. All rights reserved.
//

import Foundation

struct QuizListElement: Equatable, Codable {
    var number: Int
    var text: String
}

struct QuizList : Collection, Codable, Equatable {
    typealias Index = Int
    typealias Element = QuizListElement

    init() {
        itemList =  [
            QuizListElement(number:  1, text: "Surprise"),
            QuizListElement(number:  2, text: "Fear"),
            QuizListElement(number:  3, text: "Ruthless efficiency"),
            QuizListElement(number:  4, text: "Almost fanatical devotion to the Pope"),
            QuizListElement(number:  5, text: "Nice red uniforms"),
        ]
    }
    
    private let itemList: [QuizListElement]
    
    var startIndex: Int { return itemList.startIndex }
    var endIndex: Int { return itemList.endIndex }
    
    subscript(position: Int) -> QuizListElement {
        _read {
            yield(itemList[position])
        }
    }

    func index(after i: Int) -> Int {
        return itemList.index(after: i)
    }
    
    static func ==(lhs: [QuizListElement], rhs: QuizList) -> Bool {
        return lhs == rhs.itemList
    }
}
