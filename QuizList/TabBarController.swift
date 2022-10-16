//
//  TabBarController.swift
//  QuizList
//
//  Created by Alexander v. Below on 11.06.19.
//  Copyright © 2019 None. All rights reserved.
//

import UIKit

protocol ListController {
    var list: QuizList! { get set }
}

class TabBarController: UITabBarController, ListController {

    var list: QuizList!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let settingsView = SettingsViewHostingController(
            rootView: SettingsView())
        settingsView.tabBarItem = UITabBarItem(
            title: NSLocalizedString("Settings", comment: ""),
            image: UIImage.init(systemName: "gear"),
            selectedImage: nil)
        self.viewControllers?.append(settingsView)
        
        do {
            
            if let bundleName = UserDefaults().object(forKey: "CurrentList") as? String {
                let url = FileManager.default.documentsDirURL.appendingPathComponent(bundleName)
                if  let dataBundle = Bundle(url: url) {
                    if let dataFileUrl = dataBundle.url(
                        forResource: "data",
                        withExtension: "json") {
                        
                        let data = try Data(contentsOf: dataFileUrl)
                        let decoder = JSONDecoder()
                        list = try decoder.decode(QuizList.self, from: data)
                        
                    }
                }
            }
        }
        catch let error {
            NSLog("\(error.localizedDescription)")
        }
        if list == nil {
            list = QuizList()
        }
        
        if let array: [UIViewController] = self.viewControllers {
            for vc in array  {
                var vc = vc
                if let nc = vc as? UINavigationController {
                    vc = nc.viewControllers[0]
                }
                if var listController = vc as? ListController {
                    listController.list = self.list
                }
            }
        }
    }
}
