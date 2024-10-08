//
//  UserService.swift
//  ThreadsClone
//
//  Created by Mohammad Awais on 9/25/24.
//

import FirebaseAuth
import FirebaseFirestore

class UserService {
    @Published var currentUser: UserModel?
    
    static let instance = UserService()
    
    private var userCollection = Firestore.firestore().collection("threadsUsers");
    
    init() {
        Task { try await fetchCurrentUser() }
    }
    
    func fetchCurrentUser(uid: String? = nil) async throws {
        // Use the passed uid or fallback to the current user's uid if not provided
        guard let docId = uid ?? Auth.auth().currentUser?.uid else { return }
        
        let snapshot = try await userCollection.document(docId).getDocument()
        let user = try snapshot.data(as: UserModel.self)
        self.currentUser = user
        
//        print("DEBUG: UserService: fetchUser: \(user)")
    }
    
    func fetchUsers() async throws -> [UserModel] {
        guard let currentUid = Auth.auth().currentUser?.uid else { return [] }
        let snapshot = try await userCollection.getDocuments()
        let users = snapshot.documents.compactMap({ try? $0.data(as: UserModel.self) })
        return users.filter({ $0.id != currentUid })
    }
    
    func fetchUser(withUid uid: String) async throws -> UserModel {
        let snapshot = try await userCollection.document(uid).getDocument()
        return try snapshot.data(as: UserModel.self)
    }
    
    func updateUserProfileImage(withImageUrl imageUrl: String) async throws {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        try await userCollection.document(currentUid).updateData([
            "profileImageUrl": imageUrl
        ])
        self.currentUser?.profileImageUrl = imageUrl
    }
    
//    func updateUserData(user: UserModel) async throws {
//        guard let currentUid = Auth.auth().currentUser?.uid else { return }
//        try await userCollection.document(currentUid).setData(<#T##documentData: [String : Any]##[String : Any]#>)
//    }
}
