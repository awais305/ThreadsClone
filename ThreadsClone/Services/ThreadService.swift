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
    
    static func fetchSingleUserThreads(uid: String) async throws -> [ThreadsModel] {
        // Fetching the threads collection where the 'ownerUid' matches the input 'uid'
        let snapshot = try await threadsCollection
            .whereField("ownerUid", isEqualTo: uid)
            .getDocuments()
        
        // Fetch the user object associated with this 'uid'
        let user = try await UserService.instance.fetchUser(withUid: uid)
        
        // Map through the documents, decode each as 'ThreadsModel', and assign the fetched user
        let threads = snapshot.documents.compactMap { document -> ThreadsModel? in
            var thread = try? document.data(as: ThreadsModel.self)
            thread?.user = user
            return thread
        }
        
        // Sort the threads by 'createdAt' in descending order and return
        return threads.sorted(by: { $0.createdAt.dateValue() > $1.createdAt.dateValue() })
    }
    
    static func likeThread(docId: String, uid: String) async throws {
        try await threadsCollection.document(docId).updateData([
            "likes": FieldValue.arrayUnion([uid])
            ])
    }

}
