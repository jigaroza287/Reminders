//
//  RemindersTests.swift
//  RemindersTests
//
//  Created by Jigar Oza on 19/01/25.
//

import XCTest
import CoreData
@testable import Reminders

final class RemindersTests: XCTestCase {
    var viewModel : ReminderViewModel!
    var persistenceController : PersistenceController!

    override func setUpWithError() throws {
        try super.setUpWithError()
        viewModel = ReminderViewModel()
        persistenceController = PersistenceController()
    }

    override func tearDownWithError() throws {
        deleteAllRecords()
        viewModel = nil
        persistenceController = nil
        try super.tearDownWithError()
    }
    
    func testFetchReminders_withoutSearchQuery() {
        addReminder(title: "Test title", dueDate: Date())
        
        viewModel.fetchReminders()
        
        XCTAssertEqual(viewModel.reminders.count, 1, "Should fetch all reminders")
        XCTAssertEqual(viewModel.reminders.first?.title, "Test title", "Reminder title should match")
    }
    
    func testFetchReminders_withSearchQuery() {
        let expectation = XCTestExpectation(description: "fetchReminder fetches reminders as per search query")
        
        addReminder(title: "Test title 1", dueDate: Date())
        addReminder(title: "Test title 2", dueDate: Date())
        
        viewModel.searchQuery = "title 1"
                
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
            XCTAssertEqual(self.viewModel.reminders.count, 1, "Should fetch matching reminders")
            XCTAssertEqual(self.viewModel.reminders.first?.title, "Test title 1", "Reminder title should match")
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testAddReminder() {
        viewModel.reminderTitle = "Test Title"
        viewModel.reminderNote = "Test Note"
        viewModel.reminderSelectedPriority = .high
        
        viewModel.addReminder()
        
        let reminder = viewModel.reminders.first
        
        XCTAssertEqual(viewModel.reminders.count, 1, "Reminder title should match")
        XCTAssertEqual(reminder?.title, "Test Title", "Reminder title should match")
        XCTAssertEqual(reminder?.note, "Test Note", "Reminder note should match")
        XCTAssertEqual(reminder?.priority, ReminderPriority.high.rawValue, "Reminder priority should match")
    }
    
    func testEditReminder() {
        addReminder(title: "Test reminder", note: "Test note", priority: .medium, dueDate: Date())
        viewModel.fetchReminders()
        
        if let reminder = viewModel.reminders.first {
            viewModel.startEditingReminder(reminder)
            
            viewModel.reminderTitle = "Updated Test reminder"
            viewModel.reminderNote = "Updated Test note"
            viewModel.reminderSelectedPriority = .high
            viewModel.saveEditedReminder()
            
            let updatedReminder = viewModel.reminders.first
            
            XCTAssertEqual(updatedReminder?.title, "Updated Test reminder", "Reminder updated title should match")
            XCTAssertEqual(updatedReminder?.note, "Updated Test note", "Reminder updated note should match")
            XCTAssertEqual(updatedReminder?.priority, ReminderPriority.high.rawValue, "Reminder updated priority should match")
        }
    }
    
    func testDeleteReminder() {
        addReminder(title: "Test reminder", dueDate: Date())
        viewModel.fetchReminders()

        if let reminder = viewModel.reminders.first {
            viewModel.deleteReminder(reminder)
            XCTAssertEqual(viewModel.reminders.count, 0)
        }
    }
    
    func testToggleReminderCompletion() {
        addReminder(title: "Test reminder", dueDate: Date())
        viewModel.fetchReminders()

        if let reminder = viewModel.reminders.first {
            viewModel.toggleReminderCompletion(reminder)
            XCTAssertTrue(viewModel.reminders.first?.isComplete ?? false, "Reminder should be marked as complete")

            viewModel.toggleReminderCompletion(reminder)
            XCTAssertFalse(viewModel.reminders.first?.isComplete ?? false, "Reminder should be marked as complete")
        }
    }
    
    @discardableResult
    private func addReminder(title: String, note: String = "", priority: ReminderPriority = .low, dueDate: Date?) -> Reminder {
        let reminder = Reminder(context: persistenceController.container.viewContext)
        reminder.title = title
        reminder.note = note
        reminder.priority = priority.rawValue
        reminder.dueDate = dueDate
        persistenceController.saveContext()
        return reminder
    }
    
    private func deleteAllRecords() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Reminder")
        
        do {
            let objects = try persistenceController.container.viewContext.fetch(fetchRequest) as? [NSManagedObject] ?? []
            for object in objects {
                persistenceController.container.viewContext.delete(object)
            }
            persistenceController.saveContext()
        } catch {
            print("Error deleting all records from Reminder: \(error.localizedDescription)")
        }
    }
}
