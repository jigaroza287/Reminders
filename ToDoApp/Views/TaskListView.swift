//
//  TaskListView.swift
//  ToDoApp
//
//  Created by Jigar Oza on 20/01/25.
//

import SwiftUI

struct TaskListView: View {
    @StateObject private var viewModel = TaskViewModel()
    @State private var newTaskTitle = ""
    @State private var newTaskNote = ""
    @State var selectedPriority: TaskPriority? = .low
    @FocusState private var isTextFieldFocused: Bool

    var body: some View {
        NavigationStack {
            VStack {
                TaskSearchView(viewModel: viewModel)
                List {
                    ForEach(viewModel.tasks, id: \.objectID) { task in
                        TaskRowView(task: task, viewModel: viewModel)
                    } // List of tasks
                    .onDelete { indexSet in
                        indexSet.forEach { index in
                            let task = viewModel.tasks[index]
                            viewModel.deleteTask(task)
                        }
                    } // onDelete task event
                    NewTaskView(viewModel: viewModel)
                } // List
                .contentMargins(.top, 16)
            } // VStack
            .navigationTitle("To-Do List")
        } // NavigationStack
    }
}

#Preview {
    TaskListView()
}
