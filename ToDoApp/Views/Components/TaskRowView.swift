//
//  TaskRowView.swift
//  ToDoApp
//
//  Created by Jigar Oza on 19/01/25.
//
import SwiftUI

struct TaskRowView: View {
    let task: Task
    @ObservedObject var viewModel: TaskViewModel
    
    private let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd/MM/yy, hh:mm a"
            return formatter
        }()
    
    var titleForegroundColor: Color {
        task.isComplete ?
            .gray :
            .primary
    }
    
    var reminderDateForegroundColor: Color {
        task.reminderDate ?? Date() <= Date() ?
            .red :
            .gray
    }
    
    var body: some View {
        HStack {
            Button(action: {
                viewModel.toggleTaskCompletion(task)
            }) {
                Image(systemName: task.isComplete ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(task.isComplete ? .green : .gray)
                    .scaleEffect(task.isComplete ? 1.2 : 1.0)
            }
            .buttonStyle(PlainButtonStyle())
            .padding(.trailing, 8)
            VStack(alignment: .leading) {
                Text(TaskPriority(rawValue: task.priority ?? "").displayText())
                    .font(.subheadline)
                    .foregroundColor(.blue)
                + Text(task.title ?? "")
                    .strikethrough(task.isComplete)
                    .foregroundColor(titleForegroundColor)
                if let note = task.note, !note.isEmpty {
                    Text(note)
                        .font(.footnote)
                        .strikethrough(task.isComplete)
                        .foregroundColor(.gray)
                }
                if let reminderDate = task.reminderDate {
                    Text(dateFormatter.string(from: reminderDate))
                        .font(.footnote)
                        .strikethrough(task.isComplete)
                        .foregroundColor(reminderDateForegroundColor)
                    
                }
            }
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    let task = Task.preview(in: context)
    let viewModel = TaskViewModel()
    TaskRowView(task: task, viewModel: viewModel)
        .background(.red)
}
