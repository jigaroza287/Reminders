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
                TextField("Search tasks...", text: $viewModel.searchQuery)
                    .textFieldStyle(.roundedBorder)
                    .focused($isTextFieldFocused)
                    .padding([.horizontal, .top])
                    .overlay(
                        HStack {
                            Spacer()
                            if !viewModel.searchQuery.isEmpty {
                                Button(action: {
                                    viewModel.searchQuery = ""
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .imageScale(.small)
                                        .foregroundColor(.gray)
                                } // Button - Clear
                                .padding(.trailing, 24)
                                .padding(.top, 16)
                            }
                        } // HStack
                    ) // Overlay - Clear button
                List {
                    ForEach(viewModel.tasks, id: \.objectID) { task in
                        TaskRowView(task: task, viewModel: viewModel)
                    }
                    .onDelete { indexSet in
                        indexSet.forEach { index in
                            let task = viewModel.tasks[index]
                            viewModel.deleteTask(task)
                        }
                    } // onDelete task event
                    HStack(alignment: .top) {
                        VStack(alignment: .leading) {
                            TextField("New Task", text: $newTaskTitle)
                                .focused($isTextFieldFocused)
                            TextField("Note", text: $newTaskNote)
                                .focused($isTextFieldFocused)
                                .font(.footnote)
                                .padding(.top, 4)
                            Picker("Priority", selection: $selectedPriority) {
                                ForEach(TaskPriority.allCases, id: \.self) { priority in
                                    Text(priority.rawValue).tag(priority)
                                }
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            .padding(.top, 4)
                        } // VStack - New task
                        .padding(.vertical, 8)
                        Button(action: {
                            guard !newTaskTitle.isEmpty else { return }
                            viewModel.addTask(title: newTaskTitle, note: newTaskNote, priority: selectedPriority)
                            newTaskTitle = ""
                            newTaskNote = ""
                            selectedPriority = .low
                            isTextFieldFocused = false
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .font(.title)
                                .foregroundColor(.blue)
                        } // Button - Add task
                    } // HStack - New task
                    
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
