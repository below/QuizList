//
//  ListOrderTableViewController.swift
//  QuizList
//
//  Created by Alexander v. Below on 11.06.19.
//  Copyright © 2019 None. All rights reserved.
//

import UIKit

class ListOrderTableViewController: UITableViewController, ListController {
    var list: QuizList!
    
    var quizList = [QuizListElement]()
    var showHints = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.clearsSelectionOnViewWillAppear = false
        self.reshuffle()
    }

    func allInPlace () -> Bool {
        return quizList == list
    }
    
    @IBAction func reshuffle () {
        var mutableList = [QuizListElement]()
        for element in self.list {
            mutableList.append(element)
        }
        self.quizList = mutableList.shuffled()
        self.isEditing = true
        self.tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quizList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuizListCell", for: indexPath)

        let element = quizList[indexPath.row]
        cell.textLabel?.text = element.text
        
        if showHints {
            let fontSize = cell.textLabel?.font.pointSize ?? 17
            var font: UIFont!
            if element == list[indexPath.row] {
                font = UIFont.boldSystemFont(ofSize: fontSize)
            } else {
                font = UIFont.systemFont(ofSize: fontSize)
            }
            cell.textLabel?.font = font
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        
        let movedObject = self.quizList[fromIndexPath.row]
        self.quizList.remove(at: fromIndexPath.row)
        self.quizList.insert(movedObject, at: to.row)
        
        if allInPlace() {
            self.isEditing = false
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Reshuffle", style: .done, target: self, action: #selector(reshuffle))
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
