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
    @Published var taskToEdit: Task?
    @Published var searchQuery: String = ""
    
    let addTaskButtonTapAction = PassthroughSubject<Void, Never>()
    private let persistenceController = PersistenceController.shared
    private let container: NSPersistentContainer
    private var cancellables = Set<AnyCancellable>()

    init() {
        self.container = persistenceController.container
        setupSearchQueryBinding()
        fetchTasks()
    }

    private func setupSearchQueryBinding() {
        $searchQuery
            .removeDuplicates()
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.fetchTasks()
            }
            .store(in: &cancellables)
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
        configureTask(newTask)
        saveChanges()
        resetTaskData()
    }

    func startEditingTask(_ task: Task) {
        taskToEdit = task
        taskTitle = task.title ?? ""
        taskNote = task.note ?? ""
        taskSelectedPriority = TaskPriority.getTaskPriority(task.priority)
    }

    func saveEditedTask() {
        guard let task = taskToEdit else { return }
        configureTask(task)
        saveChanges()
        resetTaskData()
    }

    func deleteTask(_ task: Task) {
        container.viewContext.delete(task)
        saveChanges()
    }

    func toggleTaskCompletion(_ task: Task) {
        task.isComplete.toggle()
        saveChanges()
    }

    private func configureTask(_ task: Task) {
        task.title = taskTitle
        task.note = taskNote
        task.priority = taskSelectedPriority.rawValue
        if task.timestamp == nil {
            task.timestamp = Date()
        }
    }

    private func saveChanges() {
        persistenceController.saveContext()
        fetchTasks()
    }

    private func resetTaskData() {
        taskTitle = ""
        taskNote = ""
        taskSelectedPriority = .low
        taskToEdit = nil
    }
}
