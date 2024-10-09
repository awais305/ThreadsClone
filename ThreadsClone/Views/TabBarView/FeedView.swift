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
                        NavigationLink(value: thread) {
                            ThreadTileWidget(thread: thread)
                        }
                    }
                }
            }
            .refreshable {
                print("refreshing..")
                threadsVM.fetchFeedThreadsRealTime()
            }
            .navigationDestination(for: ThreadsModel.self, destination: { thread in
                Text("Threads Comments View")
            })
            .navigationTitle("Threads")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem {
                    Button{
                        threadsVM.fetchFeedThreadsRealTime()
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
