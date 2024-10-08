//
//  ProfileContentSection.swift
//  ThreadsClone
//
//  Created by Mohammad Awais on 10/1/24.
//

import SwiftUI

struct ProfileContentSection: View {
    @StateObject var threadVM = ThreadsViewModel()
    @State private var selectedFilter: ThreadsFilterEnum = .threads
    @Namespace var animation
    let uid: String?
    
    private var filterBarWidth: CGFloat {
        let count = CGFloat(ThreadsFilterEnum.allCases.count)
        return UIScreen.main.bounds.width / count - 20
    }
    
    var body: some View {
        VStack {
            HStack {
                ForEach(ThreadsFilterEnum.allCases, id: \.self) { filter in
                    VStack {
                        Text(filter.title)
                            .font(.subheadline)
                            .fontWeight(selectedFilter == filter ? .semibold : .regular)
                        
                        if selectedFilter == filter {
                            Rectangle()
                                .frame(width: filterBarWidth, height: 1)
                                .foregroundStyle(.black)
                                .matchedGeometryEffect(id: "item", in: animation)
                        }
                        else{
                            Rectangle()
                                .frame(width: filterBarWidth, height: 1)
                                .foregroundStyle(.clear)
                        }
                    }
                    .onTapGesture {
                        withAnimation(.spring()) {
                            selectedFilter = filter
                        }
                    }
                }
            }
            .padding(.top, 15)
            
            if selectedFilter == .threads {
                if threadVM.isLoadingThreads {
                    ProgressView()
                        .padding(.top, 200)
                }
                if threadVM.currentUserthreads.isEmpty && !threadVM.isLoadingThreads {
                    Text("No threads yet")
                        .font(.title3)
                        .foregroundStyle(Color(.systemGray))
                        .padding(.top, 200)
                }
                ForEach (threadVM.currentUserthreads) { thread in
                    ThreadTileWidget(thread: thread)
                }
            }
        }
        .onAppear {
            Task{
                if uid == nil { return }
                print(uid!);
                try await threadVM.fetchCurrentUserThreads(withUid: uid!)
            }
        }
    }
}

#Preview {
    ProfileContentSection(uid: AuthService.instance.userSession?.uid)
}
