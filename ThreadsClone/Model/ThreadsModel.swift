//
//  ThreadModel.swift
//  ThreadsClone
//
//  Created by Mohammad Awais on 9/19/24.
//

import FirebaseFirestore

struct ThreadsModel: Identifiable, Codable, Hashable {
    @DocumentID var threadId: String?
    
    let ownerUid: String
    let caption: String
    let createdAt: Timestamp
    var likes: [String]
    
    var id: String {
        return threadId ?? NSUUID().uuidString
    }
    
    var user: UserModel?
}
