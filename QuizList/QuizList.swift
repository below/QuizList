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
            Element(number:  1, text: "Surprise"),
            Element(number:  2, text: "Fear"),
            Element(number:  3, text: "Ruthless efficiency"),
            Element(number:  4, text: "Almost fanatical devotion to the Pope"),
            Element(number:  5, text: "Nice red uniforms"),
        ]
    }
    
    private let itemList: [Element]
    
    var startIndex: Int { return itemList.startIndex }
    var endIndex: Int { return itemList.endIndex }
    
    subscript(position: Int) -> Element {
        return itemList[position]
    }

    func index(after i: Int) -> Int {
        return itemList.index(after: i)
    }
    
    static func ==(lhs: [Element], rhs: QuizList) -> Bool {
        return lhs == rhs.itemList
    }
}
