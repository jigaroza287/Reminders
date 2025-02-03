//
//  ReminderRowView.swift
//  Reminders
//
//  Created by Jigar Oza on 19/01/25.
//
import SwiftUI

struct ReminderRowView: View {
    let reminder: Reminder
    @ObservedObject var viewModel: ReminderViewModel
    
    private let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yy, hh:mm a"
            return formatter
        }()
    
    var titleForegroundColor: Color {
        reminder.isComplete ?
            .gray :
            .primary
    }
    
    var dueDateForegroundColor: Color {
        reminder.dueDate ?? Date() <= Date() ?
            .red :
            .gray
    }
    
    var body: some View {
        HStack {
            Button(action: {
                viewModel.toggleReminderCompletion(reminder)
            }) {
                Image(systemName: reminder.isComplete ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(reminder.isComplete ? .green : .gray)
                    .scaleEffect(reminder.isComplete ? 1.2 : 1.0)
            }
            .buttonStyle(PlainButtonStyle())
            .padding(.trailing, 8)
            VStack(alignment: .leading) {
                Text(ReminderPriority(rawValue: reminder.priority).displayText())
                    .font(.subheadline)
                    .foregroundColor(.blue)
                + Text(reminder.title ?? "")
                    .strikethrough(reminder.isComplete)
                    .foregroundColor(titleForegroundColor)
                if let note = reminder.note, !note.isEmpty {
                    Text(note)
                        .font(.footnote)
                        .strikethrough(reminder.isComplete)
                        .foregroundColor(.gray)
                }
                if let dueDate = reminder.dueDate {
                    Text(dateFormatter.string(from: dueDate))
                        .font(.footnote)
                        .strikethrough(reminder.isComplete)
                        .foregroundColor(dueDateForegroundColor)
                    
                }
            }
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    let reminder = Reminder.preview(in: context)
    let viewModel = ReminderViewModel()
    ReminderRowView(reminder: reminder, viewModel: viewModel)
        .background(.red)
}
