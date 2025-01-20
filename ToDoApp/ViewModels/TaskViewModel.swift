//
//  TaskViewModel.swift
//  ToDoApp
//
//  Created by Jigar Oza on 19/01/25.
//

import Foundation
import CoreData

class TaskViewModel: ObservableObject {
    let container = PersistenceController.shared.container
    @Published var tasks: [Task] = []

    init() {
        fetchTasks()
    }
    
    func fetchTasks() {
        let request: NSFetchRequest<Task> = Task.fetchRequest()
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
