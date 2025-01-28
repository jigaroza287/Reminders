//
//  TaskListView.swift
//  ToDoApp
//
//  Created by Jigar Oza on 20/01/25.
//

import SwiftUI

struct TaskListView: View {
    @StateObject private var viewModel = TaskViewModel()
    @State private var isEditing: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                TaskSearchView(viewModel: viewModel)
                List {
                    Section(footer: NewTaskView(viewModel: viewModel)) {
                        ForEach(viewModel.tasks, id: \.objectID) { task in
                            TaskRowView(task: task, viewModel: viewModel)
                                .onTapGesture {
                                    viewModel.startEditingTask(task)
                                    isEditing = true
                                }
                        }
                        .onDelete { indexSet in
                            indexSet.forEach { index in
                                let task = viewModel.tasks[index]
                                viewModel.deleteTask(task)
                            }
                        }
                    }
                }
                .contentMargins(.top, 16)
            }
            .navigationTitle("To Do List")
            .sheet(isPresented: $isEditing) {
                NewTaskView(viewModel: viewModel, isEditing: true)
            }
        }
    }
}

#Preview {
    TaskListView()
}
