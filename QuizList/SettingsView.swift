//
//  SettingsView.swift
//  QuizList
//
//  Created by Alexander von Below on 05.09.22.
//  Copyright © 2022 None. All rights reserved.
//

import SwiftUI

struct SettingsView: View {
    @State var quizLists = ["Default"]
    @State private var selectedList: String = "Default"
    @AppStorage("CurrentList") var currentList: String = ""
    var body: some View {
        VStack {
            Picker("Select a QuizList",
                   selection: $selectedList) {
                ForEach(quizLists, id: \.self) {
                    Text(NSString(string: $0).deletingPathExtension)
                }
            }
                   .onChange(of: selectedList, perform: { newValue in
                       currentList = newValue
                       syncCollectionToSecureStorage()
                   })
                   .padding()
            Button("Reload") {
                self.reloadLists()
            }
            .padding()
            Button("Sync") {
                self.syncCollectionToSecureStorage()
            }
            .padding()
        }
    }
   
    func syncCollectionToSecureStorage() {
        let sourceURL = FileManager.default.documentsDirURL
            .appendingPathComponent(currentList)
        if let containerURL = FileManager.default.containerURL(
            forSecurityApplicationGroupIdentifier: Constants.GroupIdentifier.rawValue) {
            let targetURL = containerURL.appendingPathComponent(currentList)
            do {
                try FileManager.default.copyItem(
                 at: sourceURL,
                 to: targetURL)
            } catch {
                let nsError = error as NSError
                if nsError.domain == NSPOSIXErrorDomain, nsError.code == 17 {
                    // File exists
                    return
                }
                print ("Unable to copy: \(error)")
            }
        }
    }
    
    func reloadLists () {
        
        let fm = FileManager.default
        if let contents = try? fm.contentsOfDirectory(
            at: fm.documentsDirURL,
            includingPropertiesForKeys: nil) {
            let lists = contents.compactMap {
                url -> String? in
                guard url.pathExtension == Constants.FileExtenstion.rawValue else {
                    return nil
                }
                return url.lastPathComponent
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
