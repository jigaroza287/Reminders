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
    
    var body: some View {
        HStack {
            Button(action: {
                viewModel.toggleTaskCompletion(task)
            }) {
                Image(systemName: task.isComplete ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(task.isComplete ? .green : .gray)
                    .scaleEffect(task.isComplete ? 1.2 : 1.0)
                    .animation(.spring(), value: task.isComplete)
            }
            .padding(.trailing, 8)
            VStack(alignment: .leading) {
                Text(task.title ?? "")
                    .strikethrough(task.isComplete)
                    .foregroundColor(task.isComplete ? .gray : .primary)
                if let note = task.note {
                    Text(note)
                        .font(.footnote)
                        .strikethrough(task.isComplete)
                        .foregroundColor(.gray)
                }
            }
        } // HStack
        .padding(.vertical, 8)
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    let task = Task.preview(in: context)
    let viewModel = TaskViewModel()
    TaskRowView(task: task, viewModel: viewModel)
        .environment(\.managedObjectContext, context) // Pass the context to your view
}
