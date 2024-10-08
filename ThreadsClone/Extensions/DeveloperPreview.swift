//
//  DeveloperPreview.swift
//  ThreadsClone
//
//  Created by Mohammad Awais on 9/29/24.
//


import SwiftUI
import Firebase

class DeveloperPreview {
    static let shared = DeveloperPreview()
    
    let user = UserModel(id: NSUUID().uuidString, fullname: "Tommy Shelby", email: "tommy@gmail.com", username: "tommy_shelby1")
    
    let thread = ThreadsModel(ownerUid: "123", caption: "This is a test thread", createdAt: Timestamp(), likes: [])
}
