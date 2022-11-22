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
    var image: UIImage?

    var body: some View {
        VStack {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } else {
                Image(systemName: "checkmark.circle.fill")
                    .resizable()
                    .imageScale(.large)
                    .foregroundColor(.green)
                    .aspectRatio(contentMode: .fit)
            }
            Button("Thank You!") {
                dismiss()
            }
        }
    }
}

struct WinningView_Previews: PreviewProvider {
    static var previews: some View {
        WinningView(image:UIImage(named: "SampleImage"))
    }
}
