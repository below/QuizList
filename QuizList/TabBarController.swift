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

        if false {
            do {
                if let url = Bundle.main.url(forResource: "QuizList", withExtension: "json") {

                    let data = try Data(contentsOf: url)
                    let decoder = JSONDecoder()
                    list = try decoder.decode(QuizList.self, from: data)
                }
            }
            catch {
            }
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
