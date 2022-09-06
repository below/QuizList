//
//  WinningView.swift
//  QuizList
//
//  Created by Alexander von Below on 07.08.22.
//  Copyright © 2022 None. All rights reserved.
//

import SwiftUI

struct WinningView: View {
    @Environment(\.dismiss) var dismiss
    var image: UIImage

    var body: some View {
        Image(uiImage: image)
        Button("Thank You!") {
            dismiss()
        }
    }
}

struct WinningView_Previews: PreviewProvider {
    static var previews: some View {
        if let image = UIImage(systemName: "gear") {
            WinningView(image: image)
        }
    }
}
