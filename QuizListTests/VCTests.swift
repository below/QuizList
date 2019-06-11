//
//  VCTests.swift
//  QuizListTests
//
//  Created by Alexander v. Below on 11.06.19.
//  Copyright © 2019 None. All rights reserved.
//

import XCTest
@testable import QuizList

class VCTests: XCTestCase {

    let vc = ViewController()
    let list = QuizList()
    
    override func setUp() {
    }

    override func tearDown() {
    }

    func testRandom() {
        let x = vc.randomIndex()
        XCTAssert(x >= list.startIndex && x <= list.count-1)
    }

}
