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
                HStack {
                    TextField("Search tasks...", text: $viewModel.searchQuery)
                        .textFieldStyle(.roundedBorder)
                        .padding([.horizontal, .top])
                        .accessibilityIdentifier("RemindersSearchTextField")
                    Menu {
                        Picker(selection: $viewModel.selectedSortingOption, label: EmptyView()) {
                            ForEach(ReminderSortingOption.allCases, id: \.self) { option in
                                Text(option.rawValue).tag(option)
                            }
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                            .padding(.top, 16)
                            .padding(.trailing, 16)
                    }
                    .accessibilityIdentifier("RemindersSortingMenu")
                }
                
                List {
                    Section(footer: NewReminderView(viewModel: viewModel)) {
                        ForEach(viewModel.reminders, id: \.objectID) { reminder in
                            ReminderRowView(reminder: reminder, viewModel: viewModel)
                                .onTapGesture {
                                    viewModel.startEditingReminder(reminder)
                                    isEditing = true
                                }
                                .accessibilityIdentifier("ReminderRowView_\(reminder.objectID.uriRepresentation().absoluteString)")
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
