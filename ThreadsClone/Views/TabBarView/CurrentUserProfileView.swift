//
//  ProfileView.swift
//  ThreadsClone
//
//  Created by Mohammad Awais on 9/18/24.
//

import SwiftUI

struct CurrentUserProfileView: View {
    @StateObject var contentViewModel = ContentViewModel()
    @State var isPresented: Bool = false
    
    private var currentUser: UserModel? {
        contentViewModel.userModel
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    ProfileHeader(user: currentUser)
                    
                    HStack {
                        Button {
                            isPresented.toggle()
                        } label: {
                            Text("Edit Profile")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                        }
                        .foregroundStyle(.black)
                        .frame(width: UIScreen.main.bounds.width / 2 - 20, height: 32)
                        .overlay {
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color(.systemGray4), lineWidth: 1)
                        }
                        
                        Button {
                            
                        } label: {
                            Text("Share Profile")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                        }
                        .foregroundStyle(.black)
                        .frame(width: UIScreen.main.bounds.width / 2 - 20, height: 32)
                        .overlay {
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color(.systemGray4), lineWidth: 1)
                        }
                    }
                    
                    ProfileContentSection(uid: currentUser?.id)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        AuthService.instance.signOut()
                    } label: {
                        Image(systemName: "line.3.horizontal")
                            .foregroundStyle(.black)
                    }
                }
            }
            .sheet(isPresented: $isPresented) {
                EditProfileView(user: currentUser, isPresented: $isPresented)
            }
        }
    }
}

#Preview {
    CurrentUserProfileView()
}
