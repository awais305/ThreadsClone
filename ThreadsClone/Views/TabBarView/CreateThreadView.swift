//
//  CreateView.swift
//  ThreadsClone
//
//  Created by Mohammad Awais on 9/18/24.
//

import SwiftUI

struct CreateThreadView: View {
    @State private var caption = ""
    @Environment(\.dismiss) private var onDismiss
    @StateObject private var threadsVM = ThreadsViewModel()
    
    private var user: UserModel? {
        return UserService.instance.currentUser
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack(alignment: .top) {
                    CircularImageView(user: user, size: .small)
                    VStack(alignment: .leading, spacing: 4) {
                        Text(user?.username ?? "")
                            .font(.footnote)
                            .fontWeight(.semibold)
                        
                        TextField("Start a thread..", text: $caption, axis: .vertical)
                    }
                    .font(.footnote)
                    Spacer()
                    if !caption.isEmpty {
                        Button {
                            caption = ""
                        } label: {
                            Image(systemName: "xmark")
                                .resizable()
                                .frame(width: 12, height: 12)
                                .foregroundStyle(.gray)
                        }
                        
                    }
                }
                Spacer()
            }
            .padding()
            .navigationTitle("New Thread")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(
                    placement: .topBarLeading,
                    content: {
                        Button {
                            onDismiss()
                        } label: {
                            Text("Cancel")
                        }
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    }
                )
                ToolbarItem(
                    placement: .topBarTrailing,
                    content: {
                        Button {
                            Task {
                                try? await threadsVM.uploadThreads(caption: caption)
                                onDismiss()
                            }
                        } label : {
                            if threadsVM.isUploading {
                                ProgressView()
                            } else{
                                Text("Post")
                            }
                        }
                        .opacity(caption.isEmpty ? 0.5 : 1)
                        .disabled(caption.isEmpty)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    }
                )
            }
            .foregroundStyle(.black)
            .alert(item: $threadsVM.alertItem) { item in
                Alert(
                    title: Text(item.title),
                    message: Text(item.message),
                    dismissButton: .default(Text("Dismiss"))
                )
            }
            
        }
    }
}

#Preview {
    CreateThreadView()
}
