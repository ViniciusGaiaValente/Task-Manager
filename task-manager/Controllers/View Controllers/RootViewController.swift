//
//  RootViewController.swift
//  task-manager
//
//  Created by Vinicius Valente on 20/07/19.
//  Copyright © 2019 Vinicius Valente. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {
    
    //IBOutlets
    
    @IBOutlet var tasksTabelView: UITableView!
    
    //LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tasksTabelView.delegate = self
        tasksTabelView.dataSource = self
        
        if let taskList = Coredata.shared.getTaskList() {
            TaskList = taskList
        } else {
            print("could not retrive data")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        TaskList = Coredata.shared.getTaskList() ?? []
        tasksTabelView.reloadData()
    }
}

//TableView Extention

extension RootViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TaskList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell") as! TaskTableViewCell
        
        let task = TaskList[indexPath.row]
        
        let dateFormatter = DateFormatter()
        dateFormatter.weekdaySymbols = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
        dateFormatter.dateStyle = DateFormatter.Style.full
        dateFormatter.timeStyle = DateFormatter.Style.none
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateStyle = DateFormatter.Style.none
        timeFormatter.timeStyle = DateFormatter.Style.short
        
        cell.nameLabel.text = task.name
        cell.dateLabel.text = dateFormatter.string(from: task.deadline)
        cell.timeLabel.text = timeFormatter.string(from: task.deadline)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        Coredata.shared.deleteTask(name: TaskList[indexPath.row].name)
        if editingStyle == .delete {
            TaskList = Coredata.shared.getTaskList() ?? []
            tasksTabelView.reloadData()
        }
    }
}
