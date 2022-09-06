//
//  SettingsView.swift
//  QuizList
//
//  Created by Alexander von Below on 05.09.22.
//  Copyright © 2022 None. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    @State var quizLists = [URL(fileURLWithPath: "/foo/bar")]
    @State private var selectedList: URL = URL(fileURLWithPath: "/foo/bar")
    @AppStorage("CurrentList") var currentList: String = ""
    var body: some View {
        VStack {
            Picker("Select a QuizList",
                   selection: $selectedList) {
                ForEach(quizLists, id: \.self) {
                    Text($0.deletingPathExtension().lastPathComponent)
                }
            }
                   .onChange(of: selectedList, perform: { newValue in
                       let absoluteString = selectedList.absoluteString
                 
                       
                        currentList = absoluteString
                       if let url = URL(string: absoluteString) {
                           guard let bundle = Bundle(url: url) else {
                               NSLog ("Bundle with URL failed")
                               return
                           }
                           guard let pathBundle = Bundle(path: url.path) else {
                               NSLog ("Bundle with path failed")
                               return
                           }
                       }
                                          })
                   .padding()
            Button("Reload") {
                self.reloadLists()
            }
        }
    }
    
    func reloadLists () {
        
        let paths = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask)
        
        if let documentDir = paths.first,
           let contents = try? FileManager.default.contentsOfDirectory(
            at: documentDir,
            includingPropertiesForKeys: nil) {
            let lists = contents.compactMap {
                url -> URL? in
                guard url.pathExtension == "quizlist" else {
                    return nil
                }
                return url
            }
            quizLists = lists
            if let first = lists.first {
                selectedList = first
            }
        }
    }
}

#if os(iOS)
class SettingsViewHostingController: UIHostingController<SettingsView> {

    override init(rootView: SettingsView) {
        super.init(rootView: rootView)
    }
    
    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
#endif

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
