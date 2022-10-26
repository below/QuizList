//
//  BundleReaderTests.swift
//  QuizListTests
//
//  Created by Alexander von Below on 04.09.22.
//  Copyright © 2022 None. All rights reserved.
//

import XCTest
@testable import QuizList

final class BundleReaderTests: XCTestCase {
    var sutBundle: Bundle!
    var list: QuizList!
    
    override func setUpWithError() throws {
        guard let url = Bundle.main.url(
            forResource: "Data",
            withExtension: Constants.FileExtenstion.rawValue) else {
            XCTFail("Bundle was nil")
            return
        }
        sutBundle = Bundle(url: url)
        XCTAssertNotNil(sutBundle)
        guard let dataFileUrl = sutBundle.url(forResource: "data", withExtension: "json") else {
            XCTFail("data url was nil")
            return
        }
        list = QuizList(contentsOf: dataFileUrl)
        XCTAssertNotNil(list)
        guard let urls = sutBundle.urls(forResourcesWithExtension: nil, subdirectory: "images") else {
            XCTFail("URLs where nil")
            return
        }
        let pathNames = urls.map { url in
            url.lastPathComponent
        }
        list.winningPictures = pathNames
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testList() throws {
        XCTAssertEqual(list.items.count, 5, "Wrong number of list items")
    }

    func testImage() throws {
        guard let name = list.winningPictures?.first else {
            XCTFail("No image found")
            return
        }
        XCTAssertEqual(name, "Inquisición_española.png")
    }
}
