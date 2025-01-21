//
//  TaskViewModel.swift
//  ToDoApp
//
//  Created by Jigar Oza on 19/01/25.
//

import Foundation
import CoreData
import Combine

class TaskViewModel: ObservableObject {
    let container = PersistenceController.shared.container
    @Published var tasks: [Task] = []
    @Published var searchQuery: String = ""
    private var cancellables = Set<AnyCancellable>()

    init() {
        $searchQuery
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.fetchTasks()
            }
            .store(in: &cancellables)
        
        fetchTasks()
    }
    
    func fetchTasks() {
        let request: NSFetchRequest<Task> = Task.fetchRequest()
        
        if !searchQuery.isEmpty {
            request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchQuery.trimmingCharacters(in: .whitespaces))
        }
        
        do {
            tasks = try container.viewContext.fetch(request)
        } catch {
            print("Failed to fetch tasks: \(error)")
        }
    }

    func addTask(title: String, note: String? = nil) {
        let newTask = Task(context: container.viewContext)
        newTask.title = title
        newTask.note = note
        newTask.isComplete = false
        newTask.timestamp = Date()
        
        saveContext()
        fetchTasks()
    }
    
    func deleteTask(_ task: Task) {
        container.viewContext.delete(task)
        saveContext()
        fetchTasks()
    }

    func toggleTaskCompletion(_ task: Task) {
        task.isComplete.toggle()
        saveContext()
        fetchTasks()
    }

    private func saveContext() {
        do {
            try container.viewContext.save()
        } catch {
            print("Failed to save context: \(error)")
        }
    }

}
