//
//  ExploreViewModel.swift
//  ThreadsClone
//
//  Created by Mohammad Awais on 9/29/24.
//

import Foundation

class ExploreViewModel: ObservableObject {
    @Published var users = [UserModel]()
    
    init() {
        Task { try await fetchUsers() }
    }
    
    @MainActor
    private func fetchUsers() async throws {
        self.users = try await UserService.instance.fetchUsers()
    }
}
