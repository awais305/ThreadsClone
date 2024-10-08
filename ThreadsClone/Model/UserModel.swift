//
//  UserModel.swift
//  ThreadsClone
//
//  Created by Mohammad Awais on 9/18/24.
//

import Foundation

struct UserModel: Identifiable, Codable, Hashable{
    let id: String
    let fullname: String
    let email: String
    let username: String
    var profileImageUrl: String?
    var bio: String?
}
