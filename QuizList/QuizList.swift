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

    static func ==(lhs: QuizListElement, rhs: QuizListElement) -> Bool {
        return lhs.text == rhs.text
    }

}

struct QuizList : Codable  {
    typealias Index = Int
    typealias Element = QuizListElement

    init() {
        version = 2.0
        items =  [
            Element(number:  1, text: "Surprise"),
            Element(number:  2, text: "Fear"),
            Element(number:  3, text: "Ruthless efficiency"),
            Element(number:  4, text: "Almost fanatical devotion to the Pope"),
            Element(number:  5, text: "Nice red uniforms"),
        ]
        winningPictures = []
    }
    
    let items: [Element]
    let version: Double
    let winningPictures: [String]
    
}
