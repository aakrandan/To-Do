//
//  ViewController.swift
//  ToDo
//
//  Created by Ananth  on 16/08/20.
//  Copyright © 2020 Infosys. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let tableView = UITableView()
    var tasks = [String]()
    var time = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.estimatedRowHeight = 300
        tableView.rowHeight = UITableView.automaticDimension
        
        navigationItem.title = "All Tasks"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(tapedAdd))
        
        //Add tableview to subview
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addConstraint(NSLayoutConstraint(item: tableView, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: tableView, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: tableView, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 0))
        view.addConstraint(NSLayoutConstraint(item: tableView, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1, constant: 0))
        
        
        //setup
        if !UserDefaults().bool(forKey: "setup") {
            UserDefaults().set(true, forKey: "setup")
            UserDefaults().set(0, forKey: "count")
        }
    }
    
    @objc func tapedAdd() {
        let addTaskVC = AddTaskViewController()
        addTaskVC.updateClosure = {
            DispatchQueue.main.async {
                self.tasks.removeAll()
                self.time.removeAll()
                
                guard let count = UserDefaults().value(forKey: "count") as? Int else {return}
                
                for x in 0..<count {
                    guard let task = UserDefaults().value(forKey: "task_\(x+1)") as? String else {return}
                    guard let time = UserDefaults().value(forKey: "date_\(x+1)") as? String else {return}
                    
                    self.tasks.append(task)
                    self.time.append(time)
                }
                
                self.tableView.reloadData()
            }
        }
        navigationController?.pushViewController(addTaskVC, animated: true)
    }
}



extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        
        if cell == nil {
            cell = UITableViewCell(style: .value1, reuseIdentifier: "cell")
        }
        
        cell?.textLabel?.text = tasks[indexPath.row]
        cell?.detailTextLabel?.text = time[indexPath.row]
        return cell!
    }
    
    
}

