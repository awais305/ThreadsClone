//
//  ContentViewModel.swift
//  ThreadsClone
//
//  Created by Mohammad Awais on 9/25/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

@MainActor
class ContentViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    @Published var userModel: UserModel?
    private var authListener: AuthStateDidChangeListenerHandle?
    private var userCollection: CollectionReference = Firestore.firestore().collection("threadsUsers")
    
    init() {
        authListener = Auth.auth().addStateDidChangeListener { auth, user in
            self.userSession = user
            if user != nil {
                Task { try await self.fetchUser(withUid: self.userSession!.uid) }
            }
        }
    }
    
    func fetchUser(withUid uid: String) async throws -> UserModel {
        let snapshot = try await userCollection.document(uid).getDocument()
        self.userModel = try snapshot.data(as: UserModel.self)
        return try snapshot.data(as: UserModel.self)
    }
    
    func updateUser(user: UserModel) async throws {
        try userCollection.document(userSession!.uid).setData(from: user)
    }
    
    //    private var cancellables = Set<AnyCancellable>()
    //
    //    init() {
    //        setupSubscribers()
    //    }
    //
    //    private func setupSubscribers() {
    //        AuthService.shared.$userSession.sink { [weak self] userSession in
    //            self?.userSession = userSession
    //        }.store(in: &cancellables)
    //    }
}
