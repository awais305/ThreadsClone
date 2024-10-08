//
//  ThreadTileWidget.swift
//  ThreadsClone
//
//  Created by Mohammad Awais on 10/6/24.
//

import SwiftUI

struct ThreadTileWidget: View {
    let thread: ThreadsModel
    
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
                            
                        } label: {
                            Image(systemName: thread.likes.count > 0 ? "heart.fill" : "heart")
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
                .foregroundStyle(.black)
                .padding(.top, 8)
            }
            Spacer()
            Text(thread.createdAt.toTimeAgoString())
                .font(.caption)
                .foregroundStyle(.gray)
            Image(systemName: "ellipsis")
                .padding(.vertical, 5)
        }
        .padding()
        Divider()
    }
}

#Preview {
    ThreadTileWidget(thread: DeveloperPreview.shared.thread)
}
