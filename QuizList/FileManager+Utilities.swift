//
//  FileManager+Utilities.swift
//  QuizList
//
//  Created by Alexander von Below on 16.10.22.
//  Copyright © 2022 None. All rights reserved.
//

import Foundation

extension FileManager {
    var documentsDirURL: URL {
        let paths = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask)

        return paths.first!
    }
}
