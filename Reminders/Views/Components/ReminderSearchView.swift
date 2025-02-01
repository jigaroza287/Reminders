//
//  SearchView.swift
//  Reminders
//
//  Created by Jigar Oza on 22/01/25.
//

import SwiftUI

struct ReminderSearchView: View {
    @ObservedObject var viewModel: ReminderViewModel

    var body: some View {
        TextField("Search reminders...", text: $viewModel.searchQuery)
            .textFieldStyle(.roundedBorder)
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
    }
}

#Preview {
    ReminderSearchView(viewModel: ReminderViewModel())
}
