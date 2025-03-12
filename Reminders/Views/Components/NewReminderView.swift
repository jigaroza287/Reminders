//
//  NewReminderView.swift
//  Reminders
//
//  Created by Jigar Oza on 22/01/25.
//

import SwiftUI

struct NewReminderView: View {
    @ObservedObject var viewModel: ReminderViewModel
    @FocusState private var isTextFieldFocused: Bool
    @Environment(\.dismiss) private var dismiss
    @State private var isDueDateEnabled: Bool = false
    var isEditing: Bool = false
    
    var body: some View {
        VStack {
            HStack(alignment: .center) {
                VStack(alignment: .leading) {
                    TextField("Reminder Name", text: $viewModel.reminderTitle)
                        .accessibilityIdentifier("ReminderTitleTextField")
                        .focused($isTextFieldFocused)
                    TextField("Add Note", text: $viewModel.reminderNote)
                        .accessibilityIdentifier("ReminderNoteTextField")
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
                .accessibilityIdentifier("ReminderAddOrDoneButton")
                .buttonStyle(.plain)
            }
            .padding()
            
            Picker("Priority", selection: $viewModel.reminderSelectedPriority) {
                ForEach(ReminderPriority.allCases, id: \.self) { priority in
                    Text(priority.title).tag(priority)
                }
            }
            .accessibilityIdentifier("ReminderPriorityPicker")
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal, 16)
            
            Toggle(isOn: $isDueDateEnabled) {
                Text("Due on")
            }
            .accessibilityIdentifier("ReminderDueDateEnableToggle")
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            
            if isDueDateEnabled {
                DatePicker("", selection: Binding(
                    get: { viewModel.reminderDueDate ?? Date() },
                    set: { viewModel.reminderDueDate = $0 }
                ), displayedComponents: [.date, .hourAndMinute])
                .accessibilityIdentifier("ReminderDueDateDatePicker")
                .datePickerStyle(.compact)
                .padding(.bottom, 16)
                .labelsHidden()
            }
        }
        .padding(.horizontal, isEditing ? 16 : 0)
        .background(.white)
        .onAppear {
            isDueDateEnabled = viewModel.reminderDueDate != nil
        }
    }
    
    private func handleSave() {
        guard !viewModel.reminderTitle.isEmpty else { return }
        if isEditing {
            viewModel.saveEditedReminder()
            dismiss()
        } else {
            viewModel.addReminder()
        }
        isTextFieldFocused = false
        isDueDateEnabled = false
    }
}

#Preview {
    NewReminderView(viewModel: ReminderViewModel())
}
