//
//  RegistrationViewModel.swift
//  ThreadsClone
//
//  Created by Mohammad Awais on 9/20/24.
//

import SwiftUI
import Foundation

@MainActor
class AuthViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var email = "awais@gmail.com"
    @Published var password = "12345678"
    @Published var fullname = "Mohammad Awais"
    @Published var username = "awais305"
    
    @Published var alertItem: AlertItem?
    
    
    func loginUser() async throws {
        isLoading = true
        do{
            try await AuthService.instance.login(
                withEmail: email.lowercased(),
                password: password)
            self.isLoading = false
        }
        catch {
            self.isLoading = false
            self.alertItem = AlertItem(title: "Error", message: error.localizedDescription)
        }
    }
    
    func registerUser() async throws {
        isLoading = true
        
        do{
            try await AuthService.instance.createUser(
                withEmail: email.lowercased(),
                password: password,
                fullName: fullname,
                username: username.lowercased(),
                onSuccess: {
                    self.alertItem = AlertItem(
                        title: "Success",
                        message: "User created successfully"
                    )
                    self.isLoading = false
                }
            )
        }
        catch {
            self.isLoading = false
            print("DEBUG: \(error)")
            self.alertItem = AlertItem(
                title: "Registration Error",
                message: error.localizedDescription
            )
        }
    }
}
