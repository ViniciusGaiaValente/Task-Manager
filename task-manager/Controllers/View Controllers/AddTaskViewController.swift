//
//  AddTaskViewController.swift
//  task-manager
//
//  Created by Vinicius Valente on 21/07/19.
//  Copyright © 2019 Vinicius Valente. All rights reserved.
//

import UIKit

class AddTaskViewController: UIViewController {
    
    //Outlets
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var descriptionTextField: UITextField!
    
    @IBOutlet weak var deadlineTextField: UITextField!
    
    //Actions
    
    @IBAction func deadlineEditingBegin(_ sender: UITextField) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.weekdaySymbols = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
        dateFormatter.dateStyle = DateFormatter.Style.full
        dateFormatter.timeStyle = DateFormatter.Style.short
        
        deadlineTextField.text = dateFormatter.string(from: Date(timeIntervalSinceNow: 60))
        
        let datePickerView = UIDatePicker()
        datePickerView.datePickerMode = UIDatePicker.Mode.dateAndTime
        datePickerView.minimumDate = Date(timeIntervalSinceNow: 60)
        
        sender.inputView = datePickerView
        
        datePickerView.addTarget(self, action: #selector(AddTaskViewController.datePickerValueChanged(sender:)), for: .valueChanged)
        
    }
    
    @IBAction func submitButton(_ sender: UIButton) {
        
        guard let name = nameTextField.text else { print("error 1"); return }
        guard let description = descriptionTextField.text else { print("error 2"); return }
        guard let deadlineString = deadlineTextField.text else { print("error 3"); return }

        let dateFormatter = DateFormatter()
        dateFormatter.weekdaySymbols = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
        dateFormatter.dateStyle = DateFormatter.Style.full
        dateFormatter.timeStyle = DateFormatter.Style.short

        guard let deadline = dateFormatter.date(from: deadlineString) else { print("error 4"); return }

        let task = Task(name: name, description: description, deadline: deadline)

        Coredata.shared.saveTask(task: task)
        
        navigationController?.popViewController(animated: true)
    }
    
    //LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        designSetUp()
    }
    
    //Functions
    
    func designSetUp() {
    }
    
    // 7
    @objc func datePickerValueChanged(sender:UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.weekdaySymbols = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
        dateFormatter.dateStyle = DateFormatter.Style.full
        dateFormatter.timeStyle = DateFormatter.Style.short
        
        deadlineTextField.text = dateFormatter.string(from: sender.date)
    }
}
