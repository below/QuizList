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

extension UserDefaults {
    @objc dynamic var CurrentList: String? {
        return string(forKey: "CurrentList")
    }
}

class TabBarController: UITabBarController, ListController {
    
    var list: QuizList!
    var observer: NSKeyValueObservation?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let settingsView = SettingsViewHostingController(
            rootView: SettingsView())
        settingsView.tabBarItem = UITabBarItem(
            title: NSLocalizedString("Settings", comment: ""),
            image: UIImage.init(systemName: "gear"),
            selectedImage: nil)
        self.viewControllers?.append(settingsView)
        
        observer = UserDefaults.standard.observe(\.CurrentList) { defaults, value in
            print ("KVO: Value change \(value)")
            print ("Defaults changed: \(defaults.CurrentList ?? "<NIL>")")
            self.list = self.quizBundle()
            
            self.updateViewControllers()
        }
        
        list = quizBundle()

        updateViewControllers()
    }
    
    func quizBundle() -> QuizList {
        var list: QuizList?
        
        if let bundleName = UserDefaults().object(forKey: "CurrentList") as? String {
            let url = FileManager.default.documentsDirURL.appendingPathComponent(bundleName)
            if  let dataBundle = Bundle(url: url) {
                list = QuizList(contentsOf: dataBundle)
            }
        }
        
        if list == nil {
            if let defaultDataURL: URL = Bundle.main.url(
                forResource: "Data",
                withExtension: Constants.FileExtenstion.rawValue),
               let dataBundle = Bundle(url: defaultDataURL)
            {
                list = QuizList(contentsOf: dataBundle)
            } else {
                list = QuizList()
            }
        }
        guard let list = list else {
            fatalError("Unable to create a QuizList")
        }
        return list
    }
    
    func updateViewControllers() {
        
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
    
    deinit {
        observer?.invalidate()
    }
}
