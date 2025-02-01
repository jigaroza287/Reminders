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

enum ReminderPriority: String, CaseIterable {
    case low = "low"
    case medium = "medium"
    case high = "high"
    
    static func getReminderPriority(_ value: String?) -> Self {
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
