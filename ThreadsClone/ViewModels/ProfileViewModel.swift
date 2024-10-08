////
////  ProfileViewModel.swift
////  ThreadsClone
////
////  Created by Mohammad Awais on 9/28/24.
////

import Foundation
import Combine

class ProfileViewModel: ObservableObject {
    @Published var userModel: UserModel?
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        fetchUser()
        print("User: \(userModel?.username ?? "No User")")
    }
    
    private func fetchUser() {
        UserService.instance.$currentUser.sink{ [weak self] user in
                self?.userModel = user
        }.store(in: &cancellables)
    }
}
