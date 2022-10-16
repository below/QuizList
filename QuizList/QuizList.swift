//
//  QuizList.swift
//  QuizList
//
//  Created by Alexander v. Below on 09.06.19.
//  Copyright © 2019 None. All rights reserved.
//

import Foundation
import UIKit

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
    
    let items: [Element]
    let version: Double
    var winningPictures: [String]?

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
    
    init?(contentsOf url: URL) {
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let list = try decoder.decode(QuizList.self, from: data)
            self = list
        } catch {
            return nil
        }
    }
    
    init?(contentsOf bundle: Bundle) {
        guard let dataFileUrl = bundle.url(
            forResource: "data",
            withExtension: "json") else {
            return nil
        }
        guard let list = QuizList(contentsOf: dataFileUrl) else {
            return nil
        }
        self = list
        if let imageURLs = bundle.urls(
            forResourcesWithExtension: nil,
            subdirectory: "images") {
            self.winningPictures = imageURLs.map({ url in
                url.absoluteString
            })
        }
    }
    
    var randomPicture: UIImage? {
        if let picturePath = winningPictures?.randomElement(),
           let url = URL(string: picturePath) {
            do {
                let data = try Data(contentsOf: url)
                return UIImage(data: data)
            } catch {
                return nil
            }
        } else {
            return nil
        }
    }
}
