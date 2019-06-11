//
//  QuizListTests.swift
//  QuizListTests
//
//  Created by Alexander v. Below on 09.06.19.
//  Copyright © 2019 None. All rights reserved.
//

import XCTest
@testable import QuizList

let newList = QuizList()
class QuizListTests: XCTestCase {
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCount() {
        XCTAssertEqual(newList.count, 5)
    }

    func testFirst() {
        XCTAssertEqual(newList[0].text, "Surprise")
    }
    
    func testItem1 () {
        XCTAssertEqual(newList[1].text, "Fear")
    }
    func testLastItem() {
        let foo = newList[newList.count - 1].text
        XCTAssertEqual(foo, "Nice red uniforms")
    }
}
