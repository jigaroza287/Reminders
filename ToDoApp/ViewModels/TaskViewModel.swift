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
    @Published var tasks: [Task] = []
    @Published var taskTitle: String = ""
    @Published var taskNote: String = ""
    @Published var taskSelectedPriority: TaskPriority = .low

    @Published var searchQuery: String = ""
    var addTaskButtonTapAction = PassthroughSubject<Void, Never>()
    
    let sharedPersistenceController = PersistenceController.shared
    let container = PersistenceController.shared.container
    private var cancellables = Set<AnyCancellable>()

    init() {
        $searchQuery
            .removeDuplicates()
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

    func addTask() {
        let newTask = Task(context: container.viewContext)
        newTask.title = taskTitle
        newTask.note = taskNote
        newTask.priority = taskSelectedPriority.rawValue
        newTask.isComplete = false
        newTask.timestamp = Date()
        
        sharedPersistenceController.saveContext()
        fetchTasks()
        resetNewTaskData()
    }
    
    func deleteTask(_ task: Task) {
        container.viewContext.delete(task)
        sharedPersistenceController.saveContext()
        fetchTasks()
    }

    func toggleTaskCompletion(_ task: Task) {
        task.isComplete.toggle()
        sharedPersistenceController.saveContext()
        fetchTasks()
    }
    
    private func resetNewTaskData() {
        taskTitle = ""
        taskNote = ""
        taskSelectedPriority = .low
    }
}
