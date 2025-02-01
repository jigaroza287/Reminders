//
//  ReminderListView.swift
//  Reminders
//
//  Created by Jigar Oza on 20/01/25.
//

import SwiftUI

struct ReminderListView: View {
    @StateObject private var viewModel = ReminderViewModel()
    @State private var isEditing: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                ReminderSearchView(viewModel: viewModel)
                List {
                    Section(footer: NewReminderView(viewModel: viewModel)) {
                        ForEach(viewModel.reminders, id: \.objectID) { reminder in
                            ReminderRowView(reminder: reminder, viewModel: viewModel)
                                .onTapGesture {
                                    viewModel.startEditingReminder(reminder)
                                    isEditing = true
                                }
                        }
                        .onDelete { indexSet in
                            indexSet.forEach { index in
                                let reminder = viewModel.reminders[index]
                                viewModel.deleteReminder(reminder)
                            }
                        }
                    }
                }
                .contentMargins(.top, 16)
            }
            .navigationTitle("Reminders")
            .sheet(isPresented: $isEditing) {
                NewReminderView(viewModel: viewModel, isEditing: true)
            }
        }
    }
}

#Preview {
    ReminderListView()
}
