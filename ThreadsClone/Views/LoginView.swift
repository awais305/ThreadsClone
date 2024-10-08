//
//  LoginView.swift
//  ThreadsClone
//
//  Created by Mohammad Awais on 9/17/24.
//

import SwiftUI

struct LoginView: View {
    @StateObject var authViewModel = AuthViewModel()
    @State var showPassword: Bool = false
    
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
                    
                    TextField("Enter Email", text: $authViewModel.email)
                        .textInputAutocapitalization(.none)
                        .modifier(TextFieldModifier())
                    ZStack (alignment: .trailing) {
                        if showPassword {
                            TextField("Enter Password", text: $authViewModel.password)
                                .modifier(TextFieldModifier())
                        }else{
                            SecureField("Enter Password", text: $authViewModel.password)
                                .dialogIcon(.init(systemName: "lock.fill"))
                                .modifier(TextFieldModifier())
                        }
                        Button(action: {
                            showPassword.toggle()
                        }, label: {
                            Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20)
                        })
                        .accentColor(.secondary)
                        .padding(.horizontal, 40)
                    }
                }
                NavigationLink {
                    Text("Forgot Password View")
                } label: {
                    Text("Forgot Password?")
                        .font(.footnote)
                        .fontWeight(.semibold)
                        .padding(.vertical)
                        .padding(.trailing, 28)
                        .foregroundStyle(.black)
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                
                Button {
                    if authViewModel.isLoading { return }
                    Task { try await authViewModel.loginUser() }
                } label: {
                    if authViewModel.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(1)
                    } else{
                        Text("Login")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                    }
                }
                .modifier(ButtonModifier())
                Spacer()
                Divider()
                HStack(spacing: 3) {
                    Text("Don't have an account?")
                    NavigationLink {
                        RegistrationView()
                            .navigationBarBackButtonHidden()
                    } label: {
                        Text("SignUp")
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
    LoginView()
}
