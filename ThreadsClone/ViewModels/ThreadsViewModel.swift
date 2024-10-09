//
//  ThreadsViewModel.swift
//  ThreadsClone
//
//  Created by Mohammad Awais on 10/6/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

@MainActor
class ThreadsViewModel: ObservableObject {
    @Published var threads = [ThreadsModel]()
    @Published var currentUserthreads = [ThreadsModel]()
    @Published var isUploading: Bool = false
    @Published var isLoadingThreads: Bool = false
    @Published var alertItem: AlertItem?
    
    private var userCache = [String: UserModel]()
    

    init() {
        fetchFeedThreadsRealTime()
    }
    
    func fetchCurrentUserThreads(withUid uid: String) {
        isLoadingThreads = true
        ThreadService.fetchSingleUserThreadsRealTime(uid: uid) { [weak self] threads in
            guard let self = self else { return }
            self.currentUserthreads = threads
            self.isLoadingThreads = false
        }
    }
    
    func fetchFeedThreadsRealTime() {
        isLoadingThreads = true
        ThreadService.fetchThreadsRealTime { [weak self] fetchedThreads in
            guard let self = self else { return }
            
            var threadsToShow = fetchedThreads.filter { $0.ownerUid != Auth.auth().currentUser?.uid }
            
            Task {
                await self.fetchUsers(for: &threadsToShow)
                self.threads = threadsToShow
                self.isLoadingThreads = false
            }
        }
    }

    private func fetchUsers(for threads: inout [ThreadsModel]) async {
        for i in 0..<threads.count {
            let ownerUid = threads[i].ownerUid
            
            if let cachedUser = userCache[ownerUid] {
                threads[i].user = cachedUser
            } else {
                do {
                    let threadUser = try await UserService.instance.fetchUser(withUid: ownerUid)
                    threads[i].user = threadUser
                    userCache[ownerUid] = threadUser
                } catch {
                    print("Error fetching user for thread \(ownerUid): \(error)")
                }
            }
        }
    }
    
    deinit {
        ThreadService.removeListener()
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

//    func fetchFeedThreads() async throws {
//        isLoadingThreads = true
//        do {
//            var fetchedThreads = try await ThreadService.fetchThreads()
//            
//            fetchedThreads = fetchedThreads.filter { $0.ownerUid != Auth.auth().currentUser?.uid }
//            
//            self.threads = fetchedThreads
//            
//            try await fetchUsersThreads()
//            isLoadingThreads = false
//        } catch {
//            isLoadingThreads = false
//            print("DEBUG: \(error)")
//            self.alertItem = AlertItem(
//                title: "Error",
//                message: error.localizedDescription
//            )
//        }
//    }

    
    func likeThread(threadId: String) async throws {
        print("Like Pressed")

        do {
            try await ThreadService.likeThread(threadId: threadId)
        } catch {
            print("DEBUG: \(error)")
            self.alertItem = AlertItem(
                title: "Error",
                message: error.localizedDescription
            )
        }
    }
    
    func dislikeThread(threadId: String) async throws {
        print("Dislike Pressed")
        do {
            try await ThreadService.dislikeThread(threadId: threadId)
        } catch {
            print("DEBUG: \(error)")
            self.alertItem = AlertItem(
                title: "Error",
                message: error.localizedDescription
            )
        }
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
