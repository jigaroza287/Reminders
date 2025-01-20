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
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    ForEach(viewModel.tasks, id: \.objectID) { task in
                        TaskRowView(task: task, viewModel: viewModel)
                    }
                    .onDelete { indexSet in
                        indexSet.forEach { index in
                            let task = viewModel.tasks[index]
                            viewModel.deleteTask(task)
                        }
                    }
                    HStack(alignment: .top) {
                        VStack {
                            TextField("New Task", text: $newTaskTitle)
                            TextField("Note", text: $newTaskNote)
                                .font(.footnote)
                        }
                        Button(action: {
                            guard !newTaskTitle.isEmpty else { return }
                            viewModel.addTask(title: newTaskTitle, note: newTaskNote)
                            newTaskTitle = ""
                            newTaskNote = ""
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .font(.title)
                                .foregroundColor(.blue)
                        }
                    }

                }
                .contentMargins(.top, 16)
            }
            .navigationTitle("To-Do List")
        }
    }
}

#Preview {
    TaskListView()
}
