//
//  ExploreView.swift
//  ThreadsClone
//
//  Created by Mohammad Awais on 9/18/24.
//

import SwiftUI

struct ExploreView: View {
    @StateObject private var exploreVM = ExploreViewModel()
    @State private var searchQuery = ""
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(
                    content: {
                        ForEach(exploreVM.users, id: \.self) { user in
                            NavigationLink(value: user) {
                                UserTile(user: user)
                            }
                        }
                    }
                )
                .padding()
            }
            .navigationDestination(for: UserModel.self, destination: { user in
                UserProfileView(user: user)
            })
            .navigationTitle("Search")
            .searchable(text: $searchQuery)
        }
    }
}

#Preview {
    ExploreView()
}
