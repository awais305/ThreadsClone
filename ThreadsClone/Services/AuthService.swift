//
//  AuthService.swift
//  ThreadsClone
//
//  Created by Mohammad Awais on 9/20/24.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class AuthService {
    @Published var userSession: FirebaseAuth.User?
    private var userCollection = Firestore.firestore().collection("threadsUsers");
    
    let firebaseAuth = Auth.auth()
    
    static let instance = AuthService()
    
    init() {
        self.userSession = firebaseAuth.currentUser
    }
    
    func login(withEmail email: String, password: String) async throws {
        let result = try await firebaseAuth.signIn(withEmail: email, password: password)
        self.userSession = result.user
        try await UserService.instance.fetchCurrentUser()
    }
    
    func createUser(withEmail email: String, password: String, fullName: String, username: String,
                    onSuccess: @escaping () -> Void) async throws {
        let result = try await firebaseAuth.createUser(withEmail: email, password: password)
        self.userSession = result.user
        try await createUserData(withEmail: email, fullname: fullName, username: username, id: result.user.uid, onSuccess: onSuccess)
    }
    
    private func createUserData(
        withEmail email: String,
        fullname: String,
        username: String,
        id: String,
        onSuccess: @escaping () -> Void
    ) async throws {
        let user = UserModel(id: id, fullname: fullname, email: email, username: username)
        guard let userData = try? Firestore.Encoder().encode(user) else { return }
        try await userCollection.document(id).setData(userData)
        UserService.instance.currentUser = user
        onSuccess()
    }
    
    func signOut() {
        try? firebaseAuth.signOut()
        self.userSession = nil
        UserService.instance.currentUser = nil
    }
}
