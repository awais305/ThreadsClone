//
//  ThreadsViewModel.swift
//  ThreadsClone
//
//  Created by Mohammad Awais on 10/6/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class ThreadsViewModel: ObservableObject {
    @Published var threads = [ThreadsModel]()
    @Published var currentUserthreads = [ThreadsModel]()
    @Published var isUploading: Bool = false
    @Published var isLoadingThreads: Bool = false
    @Published var alertItem: AlertItem?
    
    init() {
        Task { try await fetchFeedThreads() }
    }
    
    func uploadThreads(caption: String) async throws {
        isUploading = true
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let thread = ThreadsModel(ownerUid: uid, caption: caption, createdAt: Timestamp(), likes: [])
        do {
            try await ThreadService.createThread(ThreadsModel: thread)
            //            throw ThreadsError.uploadFailed
            self.isUploading = false
        }
        catch {
            self.isUploading = false
            print("DEBUG: \(error)")
            self.alertItem = AlertItem(
                title: "Error",
                message: error.localizedDescription
            )
        }
        
    }
    
    func fetchFeedThreads() async throws {
        isLoadingThreads = true
        do {
            var fetchedThreads = try await ThreadService.fetchThreads()
            
            fetchedThreads = fetchedThreads.filter { $0.ownerUid != Auth.auth().currentUser?.uid }
            
            self.threads = fetchedThreads
            
            try await fetchUsersThreads()
            isLoadingThreads = false
        } catch {
            isLoadingThreads = false
            print("DEBUG: \(error)")
            self.alertItem = AlertItem(
                title: "Error",
                message: error.localizedDescription
            )
        }
    }

    
    private func fetchUsersThreads() async throws {
        for i in 0 ..< threads.count {
            let ownerUid = threads[i].ownerUid
            
            let threadUser = try await UserService.instance.fetchUser(withUid: ownerUid)
            threads[i].user = threadUser
        }
    }
    
    func fetchCurrentUserThreads(withUid uid: String) async throws {
        isLoadingThreads = true
        self.currentUserthreads = try await ThreadService.fetchSingleUserThreads(uid: uid)
        isLoadingThreads = false
    }
}


enum ThreadsError: Error, LocalizedError {
    case uploadFailed
    case fetchFailed
    
    var errorDescription: String? {
        switch self {
            case .uploadFailed:
                return NSLocalizedString("Failed to upload the thread. Please try again.", comment: "")
            case .fetchFailed:
                return NSLocalizedString("Failed to fetch the thread. Please try again.", comment: "")
        }
    }
}
