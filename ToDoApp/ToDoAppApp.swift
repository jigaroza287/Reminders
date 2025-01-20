//
//  ToDoAppApp.swift
//  ToDoApp
//
//  Created by Jigar Oza on 19/01/25.
//

import SwiftUI

@main
struct ToDoAppApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            TaskListView()
        }
    }
}
