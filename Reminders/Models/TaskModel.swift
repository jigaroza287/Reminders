//
//  ReminderModel.swift
//  Reminders
//
//  Created by Jigar Oza on 20/01/25.
//

import Foundation
import CoreData

extension Reminder {
    static func preview(in context: NSManagedObjectContext) -> Reminder {
        let reminder = Reminder(context: context)
        reminder.title = "Preview Reminder"
        reminder.isComplete = false
        return reminder
    }
}

enum ReminderPriority: Int16, CaseIterable {
    case low = 0
    case medium = 1
    case high = 2
    
    var title: String {
        switch self {
        case .low:
            return "Low"
        case .medium:
            return "Medium"
        case .high:
            return "High"
        }
    }
    
    static func getReminderPriority(_ value: Int16) -> Self {
        switch value {
        case 1:
            return .medium
        case 2:
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

extension Optional where Wrapped == ReminderPriority {
    func displayText() -> String {
        switch self {
        case .some(let priority):
            return priority.displayText()
        case .none:
            return ""
        }
    }
}

enum ReminderSortingOption: String, CaseIterable {
    case dueDate = "Due Date"
    case priority = "Priority"
    case creationDate = "Creation Date"
}
