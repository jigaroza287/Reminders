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
    @Environment(\.dismiss) private var dismiss
    var isEditing: Bool = false
    
    var body: some View {
        VStack {
            HStack(alignment: .center) {
                VStack(alignment: .leading) {
                    TextField("New Task", text: $viewModel.taskTitle)
                        .focused($isTextFieldFocused)
                    TextField("Note", text: $viewModel.taskNote)
                        .focused($isTextFieldFocused)
                        .font(.footnote)
                        .padding(.top, 4)
                } // VStack - New task
                .padding(.vertical, 8)
                Button(action: {
                    guard !viewModel.taskTitle.isEmpty else { return }
                    if isEditing {
                        viewModel.saveEditedTask()
                        dismiss()
                    } else {
                        viewModel.addTask()
                    }
                    isTextFieldFocused = false
                }) {
                    if isEditing {
                        Text("Done")
                    } else {
                        Image(systemName: "plus.circle.fill")
                            .font(.title)
                            .foregroundColor(.blue)
                    }
                } // Button - Add task
                .buttonStyle(.plain)
            } // HStack - New task
            Picker("Priority", selection: $viewModel.taskSelectedPriority) {
                ForEach(TaskPriority.allCases, id: \.self) { priority in
                    Text(priority.rawValue).tag(priority)
                }
            } // Picker - Priority
            .pickerStyle(SegmentedPickerStyle())
            .padding(.top, 4)
            
        } // VStack - Top container
        .padding(.horizontal, isEditing ? 24 : 0)
    }
}

#Preview {
    NewTaskView(viewModel: TaskViewModel())
}
