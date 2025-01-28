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
    @State private var isReminderEnabled: Bool = false
    var isEditing: Bool = false
    
    var body: some View {
        VStack {
            HStack(alignment: .center) {
                VStack(alignment: .leading) {
                    TextField("Task Name", text: $viewModel.taskTitle)
                        .focused($isTextFieldFocused)
                    TextField("Add Note", text: $viewModel.taskNote)
                        .focused($isTextFieldFocused)
                        .font(.footnote)
                        .padding(.top, 4)
                }
                .padding(.vertical, 8)
                Button(action: handleSave) {
                    if isEditing {
                        Text("Done")
                    } else {
                        Image(systemName: "plus.circle.fill")
                            .font(.title)
                            .foregroundColor(.blue)
                    }
                }
                .buttonStyle(.plain)
            }
            .padding()
            
            Picker("Priority", selection: $viewModel.taskSelectedPriority) {
                ForEach(TaskPriority.allCases, id: \.self) { priority in
                    Text(priority.rawValue).tag(priority)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal, 16)
            
            Toggle(isOn: $isReminderEnabled) {
                Text("Set Reminder")
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            
            if isReminderEnabled {
                DatePicker("", selection: Binding(
                    get: { viewModel.taskReminderDate ?? Date() },
                    set: { viewModel.taskReminderDate = $0 }
                ), displayedComponents: [.date, .hourAndMinute])
                    .datePickerStyle(.compact)
                    .padding(.bottom, 16)
                    .labelsHidden()
            }
        }
        .padding(.horizontal, isEditing ? 16 : 0)
        .background(.white)
        .onAppear {
            isReminderEnabled = viewModel.taskReminderDate != nil
        }
    }
    
    private func handleSave() {
        guard !viewModel.taskTitle.isEmpty else { return }
        if isEditing {
            viewModel.saveEditedTask()
            dismiss()
        } else {
            viewModel.addTask()
        }
        isTextFieldFocused = false
        isReminderEnabled = false
    }
}

#Preview {
    NewTaskView(viewModel: TaskViewModel())
}
