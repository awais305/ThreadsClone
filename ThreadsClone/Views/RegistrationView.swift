//
//  RegistrationView.swift
//  ThreadsClone
//
//  Created by Mohammad Awais on 9/17/24.
//

import SwiftUI

struct RegistrationView: View {
    @StateObject var authViewModel = AuthViewModel()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                VStack {
                    Image(.appIcon)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 120)
                        .padding()
                    
                    TextField("Enter Full Name", text: $authViewModel.fullname)
                        .modifier(TextFieldModifier())
                    TextField("Enter Username", text: $authViewModel.username)
                        .modifier(TextFieldModifier())
                    TextField("Enter Email", text: $authViewModel.email)
                        .modifier(TextFieldModifier())
                    SecureField("Enter Password", text: $authViewModel.password)
                        .modifier(TextFieldModifier())
                }
                .padding(.vertical)
                
                Button {
                    if authViewModel.isLoading { return }
                    Task { try await authViewModel.registerUser() }
                } label: {
                    if authViewModel.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(1)
                    }else{
                        Text("Sign Up")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                    }
                }
                .modifier(ButtonModifier())
                Spacer()
                Divider()
                HStack(spacing: 3) {
                    Text("Already have an account?")
                    Button {
                        dismiss()
                    } label: {
                        Text("Login")
                            .fontWeight(.semibold)
                    }
                }
                .font(.footnote)
                .foregroundStyle(.black)
                .padding(.vertical)
            }
        }
        .alert(item: $authViewModel.alertItem) { item in
            Alert(
                title: Text(item.title),
                message: Text(item.message),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}


#Preview {
    RegistrationView()
}
