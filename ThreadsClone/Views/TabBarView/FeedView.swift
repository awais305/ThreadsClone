//
//  FeedView.swift
//  ThreadsClone
//
//  Created by Mohammad Awais on 9/18/24.
//

import SwiftUI

struct FeedView: View {
    @StateObject var threadsVM = ThreadsViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack {
                    if threadsVM.isLoadingThreads {
                        ProgressView()
                    }
                    ForEach(threadsVM.threads) { thread in
                        ThreadTileWidget(thread: thread)
                    }
                }
            }
            .refreshable {
                print("refreshing..")
                Task {
                    try await threadsVM.fetchFeedThreads()
                }
            }
            .navigationTitle("Threads")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem {
                    Button{
                        Task {
                            try await threadsVM.fetchFeedThreads()
                        }
                    } label: {
                        Image(systemName: "arrow.counterclockwise")
                    }
                    .foregroundStyle(.black)
                }
            }
        }
        .alert(item: $threadsVM.alertItem) { item in
            Alert(
                title: Text(item.title),
                message: Text(item.message),
                dismissButton: .default(Text("Try Again"))
            )
        }
    }
}

#Preview {
    NavigationStack {
        FeedView()
    }
}
