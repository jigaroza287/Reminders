//
//  BiometricAuthManager.swift
//  Reminders
//
//  Created by Jigar Oza on 10/02/25.
//

import LocalAuthentication

class BiometricAuthManager {
    static func authenticateUser(completion: @escaping (Bool, String?) -> Void) {
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Authenticate to access your reminders"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authError in
                DispatchQueue.main.async {
                    if success {
                        completion(true, nil)
                    } else {
                        let message = authError?.localizedDescription ?? "Authentication failed"
                        completion(false, message)
                    }
                }
            }
        } else {
            DispatchQueue.main.async {
                completion(false, "Biometric authentication not available")
            }
        }
    }
}
