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

    init() {
        NotificationManager.shared.requestAuthorization { granted in
            if granted {
                print("Notifications authorized.")
            } else {
                print("Notifications not authorized.")
            }
        }
    }

    var body: some Scene {
        WindowGroup {
            TaskListView()
        }
    }
}
