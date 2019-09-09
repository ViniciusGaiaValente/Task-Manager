//
//  Coredata.swift
//  task-manager
//
//  Created by Vinicius Valente on 21/07/19.
//  Copyright © 2019 Vinicius Valente. All rights reserved.
//

import UIKit
import CoreData

class Coredata: NSObject {
    
    private override init() {
        super.init()
    }
    
    static let shared = Coredata()
    
    func saveTask(task: Task) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { print("erro"); return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        guard let taskList = getTaskList() else { print("could not retrive task list"); return }
        
        for _task in taskList {
            if _task.name == task.name {
                print("there is already a task with this name")
                return
            }
        }

        let entity = NSEntityDescription.entity(forEntityName: "TaskModel", in: managedContext)!
        
        let newTask = NSManagedObject(entity: entity, insertInto: managedContext)
        
        newTask.setValue(task.name, forKeyPath: "name")
        newTask.setValue(task.description, forKeyPath: "desc")
        newTask.setValue(task.deadline, forKeyPath: "deadline")
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func getTaskList() -> [Task]? {
        
        var taskList: [Task] = []
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { print("erro"); return nil }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "TaskModel")
        
        let sort = NSSortDescriptor(key: "deadline", ascending: true)
        
        fetchRequest.sortDescriptors = [sort]
        
        do {
            let taskModels = try managedContext.fetch(fetchRequest)
            for object in taskModels {
                
                guard let name = object.value(forKey: "name") as? String else { print("erro"); return nil }
                guard let description = object.value(forKey: "desc") as? String else { print("erro"); return nil }
                guard let deadline = object.value(forKey: "deadline") as? Date else { print("erro"); return nil }
                
                let task = Task(name: name, description: description, deadline: deadline)
                
                taskList.append(task)
            }
            return taskList
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return nil
        }
    }
    
    func deleteTask(name: String) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { print("erro"); return }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "TaskModel")
        
        do {
            let taskModels = try managedContext.fetch(fetchRequest)
            for object in taskModels {
                guard let _name = object.value(forKey: "name") as? String else { print("erro"); return }
                if name == _name {
                    managedContext.delete(object)
                }
            }
        } catch {
            print("Could not fetch. \(error)")
            return
        }
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
}
