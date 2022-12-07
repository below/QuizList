//
//  QuizList.swift
//  QuizList
//
//  Created by Alexander v. Below on 09.06.19.
//  Copyright © 2019 Alexander v. Below. All rights reserved.
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
    
    init?(firstAt url: URL) throws {
        let content = try FileManager.default.contentsOfDirectory(
            at: url,
            includingPropertiesForKeys: nil)
        if let url = content.first(
            where: { $0.pathExtension == Constants.FileExtenstion.rawValue }),
           let bundle = Bundle(url: url),
           let list = QuizList(contentsOf: bundle) {
               self = list
               return
           } else {
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
    
    private func image(from path: String) -> UIImage? {
        guard let url = URL(string: path) else {
            return nil
        }
        do {
            let data = try Data(contentsOf: url)
            return UIImage(data: data)
        } catch {
            return nil
        }
    }
    
    var randomPicture: UIImage? {
        guard let picturePath = winningPictures?.randomElement() else {
            return nil
        }
        return self.image(from: picturePath)
    }
    
    var imagePaths: [URL] {
        guard let winningPictures = winningPictures else {
            return [URL]()
        }
        return winningPictures.compactMap { path in
            return URL(string: path)
        }
    }
}
