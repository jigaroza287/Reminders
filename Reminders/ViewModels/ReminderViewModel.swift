//
//  ReminderViewModel.swift
//  Reminders
//
//  Created by Jigar Oza on 19/01/25.
//

import Foundation
import CoreData
import Combine

class ReminderViewModel: ObservableObject {
    @Published var reminders: [Reminder] = []
    @Published var reminderTitle: String = ""
    @Published var reminderNote: String = ""
    @Published var reminderSelectedPriority: ReminderPriority = .low
    @Published var reminderDueDate: Date?
    @Published var reminderToEdit: Reminder?
    @Published var searchQuery: String = ""
    
    let addReminderButtonTapAction = PassthroughSubject<Void, Never>()
    private let persistenceController = PersistenceController.shared
    private let container: NSPersistentContainer
    private var cancellables = Set<AnyCancellable>()

    init() {
        self.container = persistenceController.container
        setupBinding()
        fetchReminders()
    }

    private func setupBinding() {
        $searchQuery
            .removeDuplicates()
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.fetchReminders()
            }
            .store(in: &cancellables)
    }

    func fetchReminders() {
        let request: NSFetchRequest<Reminder> = Reminder.fetchRequest()
        if !searchQuery.isEmpty {
            request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchQuery.trimmingCharacters(in: .whitespaces))
        }
        do {
            reminders = try container.viewContext.fetch(request)
        } catch {
            print("Failed to fetch reminders: \(error)")
        }
    }

    func addReminder() {
        let newReminder = Reminder(context: container.viewContext)
        configureReminder(newReminder)
        saveChanges()
        resetReminderData()
    }

    func startEditingReminder(_ reminder: Reminder) {
        reminderToEdit = reminder
        reminderTitle = reminder.title ?? ""
        reminderNote = reminder.note ?? ""
        reminderSelectedPriority = ReminderPriority.getReminderPriority(reminder.priority)
        reminderDueDate = reminder.dueDate
    }

    func saveEditedReminder() {
        guard let reminder = reminderToEdit else { return }
        configureReminder(reminder)
        saveChanges()
        resetReminderData()
    }

    func deleteReminder(_ reminder: Reminder) {
        NotificationManager.shared.removeNotification(id: reminder.objectID.uriRepresentation().absoluteString)
        container.viewContext.delete(reminder)
        saveChanges()
    }

    func toggleReminderCompletion(_ reminder: Reminder) {
        reminder.isComplete.toggle()
        saveChanges()
    }

    private func configureReminder(_ reminder: Reminder) {
        reminder.title = reminderTitle
        reminder.note = reminderNote
        reminder.priority = reminderSelectedPriority.rawValue
        if reminder.timestamp == nil {
            reminder.timestamp = Date()
        }
        reminder.dueDate = reminderDueDate
        
        if let _reminderDueDate = reminderDueDate {
            NotificationManager.shared.scheduleNotification(
                id: reminder.objectID.uriRepresentation().absoluteString,
                title: reminderTitle,
                body: reminderNote.isEmpty ? "You have a reminder to complete!" : reminderNote,
                date: _reminderDueDate
            )
        }
    }

    private func saveChanges() {
        persistenceController.saveContext()
        fetchReminders()
    }

    private func resetReminderData() {
        reminderTitle = ""
        reminderNote = ""
        reminderSelectedPriority = .low
        reminderToEdit = nil
        reminderDueDate = nil
    }
}
