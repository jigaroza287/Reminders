//
//  TaskModel.swift
//  ToDoApp
//
//  Created by Jigar Oza on 20/01/25.
//

import Foundation
import CoreData

extension Task {
    static func preview(in context: NSManagedObjectContext) -> Task {
        let task = Task(context: context)
        task.title = "Preview Task"
        task.isComplete = false
        return task
    }
}
