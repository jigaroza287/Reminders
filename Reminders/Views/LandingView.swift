//
//  LandingView.swift
//  Reminders
//
//  Created by Jigar Oza on 07/02/25.
//

import SwiftUI

struct LandingView: View {
    @State private var isAuthenticated = false
    @State private var errorMessage: String?
    
    var body: some View {
        NavigationStack {
            if isAuthenticated {
                ReminderListView()
                    .toolbar(.hidden, for: .navigationBar)
            } else {
                ZStack {
                    VStack {
                        Text("Welcome to")
                            .font(.title3).fontWeight(.bold)
                            .padding(.top, 60)
                        Text("Reminders")
                            .font(.largeTitle).fontWeight(.bold)
                            .padding(.top)
                        Spacer()
                    }
                    Button (action: authenticateUser) {
                        Image(systemName: "faceid")
                            .imageScale(.large)
                            .font(.system(size: 60))
                    }
                    .accessibilityIdentifier("AuthenticateFaceIdButton")
                }
                .task {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        authenticateUser()
                    }
                }
            }
        }
    }
    
    private func authenticateUser() {
        BiometricAuthManager.authenticateUser { success, error in
            if success {
                isAuthenticated = true
            } else {
                errorMessage = error
            }
        }
    }
}

#Preview {
    LandingView()
}
