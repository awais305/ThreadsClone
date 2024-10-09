//
//  ThreadTileWidget.swift
//  ThreadsClone
//
//  Created by Mohammad Awais on 10/6/24.
//

import SwiftUI

struct ThreadTileWidget: View {
    let thread: ThreadsModel
    let uid: String = AuthService.instance.userSession!.uid
    
    @StateObject var threadsVM = ThreadsViewModel()
    
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            CircularImageView(user: thread.user, size: .small)
            VStack(alignment: .leading) {
                Text(thread.user?.username ?? "")
                    .font(.footnote)
                    .fontWeight(.semibold)
                
                Text(thread.caption)
                    .font(.caption)
                HStack(spacing: 16) {
                    HStack(spacing: 5) {
                        Button {
                            if thread.likes.contains(uid) {
                                Task { try await threadsVM.dislikeThread(threadId: thread.id) }
                            } else {
                                Task { try await threadsVM.likeThread(threadId: thread.id) }
                            }
                        } label: {
                            Image(systemName: thread.likes.contains(uid) ? "heart.fill" : "heart")
                        }
                        if thread.likes.count > 0 {
                            Text("\(thread.likes.count)")
                                .font(.caption)
                        }
                    }
                    Button {
                        
                    } label: { Image(systemName: "bubble.right") }
                    Button {
                        
                    } label: { Image(systemName: "arrow.rectanglepath") }
                    Button {
                        
                    } label: { Image(systemName: "paperplane") }
                }
                .padding(.top, 8)
            }
            Spacer()
            Text(thread.createdAt.toTimeAgoString())
                .font(.caption)
                .foregroundStyle(.gray)
            Image(systemName: "ellipsis")
                .padding(.vertical, 5)
        }
        .foregroundStyle(.black)
        .padding()
        Divider()
    }
}

#Preview {
    ThreadTileWidget(
        thread: DeveloperPreview.shared.thread
    )
}
