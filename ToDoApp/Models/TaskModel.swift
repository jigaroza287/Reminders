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

enum TaskPriority: String, CaseIterable {
    case low = "low"
    case medium = "medium"
    case high = "high"
    
    static func getTaskPriority(_ value: String?) -> Self {
        switch value {
        case "medium":
            return .medium
        case "high":
            return .high
        default:
            return .low
        }
    }
    
    func displayText() -> String {
        switch self {
        case .high:
            return "!!! "
        case .medium:
            return "!! "
        case .low:
            return "! "
        }
    }
}

extension Optional where Wrapped == TaskPriority {
    func displayText() -> String {
        switch self {
        case .some(let priority):
            return priority.displayText()
        case .none:
            return ""
        }
    }
}
