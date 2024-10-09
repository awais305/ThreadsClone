//
//  ThreadService.swift
//  ThreadsClone
//
//  Created by Mohammad Awais on 10/5/24.
//

import Foundation
import FirebaseFirestore

struct ThreadService {
    private static let threadsCollection = Firestore.firestore().collection("threads");
    private static var listener: ListenerRegistration?
    private static var myThreadsListener: ListenerRegistration?
    
    static func createThread(ThreadsModel thread: ThreadsModel) async throws {
        guard let threadData = try? Firestore.Encoder().encode(thread) else { return }
        try await threadsCollection.addDocument(data: threadData)
    }
    
    static func fetchThreads() async throws -> [ThreadsModel] {
        let snapshot = try await threadsCollection
            .order(by: "createdAt", descending: true)
            .getDocuments()
        
        return snapshot.documents.compactMap({ try? $0.data(as: ThreadsModel.self ) })
    }
    
    //    static func fetchSingleUserThreads(uid: String) async throws -> [ThreadsModel] {
    //        let snapshot = try await threadsCollection
    //            .whereField("ownerUid", isEqualTo: uid)
    //            .getDocuments()
    //
    //        let threads = snapshot.documents.compactMap({ try? $0.data(as: ThreadsModel.self ) })
    //        return threads.sorted(by: { $0.createdAt.dateValue() > $1.createdAt.dateValue()})
    //    }
    
    
    // Real-time fetch of threads with listener
    static func fetchThreadsRealTime(completion: @escaping ([ThreadsModel]) -> Void) {
        self.listener = threadsCollection
            .order(by: "createdAt", descending: true)
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    print("Error fetching threads: \(error)")
                    return
                }
                
                let threads = snapshot?.documents.compactMap { document in
                    try? document.data(as: ThreadsModel.self)
                } ?? []
                
                completion(threads)
            }
    }
    
     static func fetchSingleUserThreadsRealTime(uid: String, completion: @escaping ([ThreadsModel]) -> Void) {
        self.myThreadsListener = ThreadService.threadsCollection
             .whereField("ownerUid", isEqualTo: uid)
             .addSnapshotListener { snapshot, error in
                 if let error = error {
                     print("Error fetching single user's threads: \(error)")
                     return
                 }
                 
                 Task {
                     guard let user = try? await UserService.instance.fetchUser(withUid: uid) else {
                         return
                     }

                     let threads = snapshot?.documents.compactMap { document -> ThreadsModel? in
                         var thread = try? document.data(as: ThreadsModel.self)
                         thread?.user = user // Assign user to each thread
                         return thread
                     } ?? []
                     
                     completion(threads.sorted(by: { $0.createdAt.dateValue() > $1.createdAt.dateValue() }))
                 }
             }
     }
    
//    static func fetchSingleUserThreads(uid: String) async throws -> [ThreadsModel] {
//        let snapshot = try await threadsCollection
//            .whereField("ownerUid", isEqualTo: uid)
//            .getDocuments()
//        
//        let user = try await UserService.instance.fetchUser(withUid: uid)
//        
//        let threads = snapshot.documents.compactMap { document -> ThreadsModel? in
//            var thread = try? document.data(as: ThreadsModel.self)
//            thread?.user = user
//            return thread
//        }
//        
//        return threads.sorted(by: { $0.createdAt.dateValue() > $1.createdAt.dateValue() })
//    }
    
    static func likeThread(threadId: String) async throws {
        guard let uid = AuthService.instance.userSession?.uid else { return }
        try await threadsCollection.document(threadId).updateData([
            "likes": FieldValue.arrayUnion([uid])
        ])
    }
    
    static func dislikeThread(threadId: String) async throws {
        guard let uid = AuthService.instance.userSession?.uid else { return }
        try await threadsCollection.document(threadId).updateData([
            "likes": FieldValue.arrayRemove([uid])
        ])
    }
    
    static func removeListener() {
        self.listener?.remove()
        self.listener = nil
        self.myThreadsListener?.remove()
        self.myThreadsListener = nil
    }
}
