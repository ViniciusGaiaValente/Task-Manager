//
//  Task.swift
//  task-manager
//
//  Created by Vinicius Valente on 21/07/19.
//  Copyright © 2019 Vinicius Valente. All rights reserved.
//

import Foundation

struct Task {
    let name: String
    let description: String
    let deadline: Date
    
    init(name: String, description: String, deadline: Date) {
        self.name = name
        self.description = description
        self.deadline = deadline
    }
}
