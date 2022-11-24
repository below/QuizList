//
//  SharedIdentifiers.swift
//  QuizList
//
//  Created by Alexander von Below on 17.10.22.
//  Copyright © 2022 None. All rights reserved.
//

import Foundation

public enum Constants: String {
    case GroupIdentifier = "group.com.vonbelow.quizlist"
    case FileExtenstion = "quizlist"
}

func ContainerURL() -> URL {
    let url = FileManager.default.containerURL(
        forSecurityApplicationGroupIdentifier: Constants.GroupIdentifier.rawValue)
    return url!
}
