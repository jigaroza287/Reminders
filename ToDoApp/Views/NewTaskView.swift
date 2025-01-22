//
//  NewTaskView.swift
//  ToDoApp
//
//  Created by Jigar Oza on 22/01/25.
//

import SwiftUI

struct NewTaskView: View {
    @ObservedObject var viewModel: TaskViewModel
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                TextField("New Task", text: $viewModel.taskTitle)
                    .focused($isTextFieldFocused)
                TextField("Note", text: $viewModel.taskNote)
                    .focused($isTextFieldFocused)
                    .font(.footnote)
                    .padding(.top, 4)
                Picker("Priority", selection: $viewModel.taskSelectedPriority) {
                    ForEach(TaskPriority.allCases, id: \.self) { priority in
                        Text(priority.rawValue).tag(priority)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.top, 4)
            } // VStack - New task
            .padding(.vertical, 8)
            Button(action: {
                guard !viewModel.taskTitle.isEmpty else { return }
                viewModel.addTask()
                isTextFieldFocused = false
            }) {
                Image(systemName: "plus.circle.fill")
                    .font(.title)
                    .foregroundColor(.blue)
            } // Button - Add task
        } // HStack - New task
    }
}

#Preview {
    NewTaskView(viewModel: TaskViewModel())
}
