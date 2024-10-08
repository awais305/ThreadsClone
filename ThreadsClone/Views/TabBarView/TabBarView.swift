//
//  TabView.swift
//  ThreadsClone
//
//  Created by Mohammad Awais on 9/18/24.
//

import SwiftUI

struct TabBarView: View {
    @State private var selectedTab = 0
    @State private var showSheet = false
    @State private var prevIndex = 0
    
    var body: some View {
        TabView(
            selection: $selectedTab,
            content:  {
                FeedView()
                    .tabItem {
                        Image(systemName: "house")
                            .environment(\.symbolVariants, selectedTab == 0 ? .fill : .none)
                    }
                    .onAppear{ selectedTab = 0 }
                    .tag(0)
                ExploreView()
                    .tabItem { Image(systemName: "magnifyingglass") }
                    .onAppear{ selectedTab = 1 }
                    .tag(1)
                Text("")
                    .background{
                        Color(.red)
                    }
                    .tabItem { Image(systemName: "plus") }
                    .onAppear{ selectedTab = 2 }
                    .tag(2)
                ActivityView()
                    .tabItem {
                        Image(systemName: "heart")
                            .environment(\.symbolVariants, selectedTab == 3 ? .fill : .none)
                    }
                    .onAppear{ selectedTab = 3 }
                    .tag(3)
                CurrentUserProfileView()
                    .tabItem {
                        Image(systemName: "person")
                            .environment(\.symbolVariants, selectedTab == 4 ? .fill : .none)
                    }
                    .onAppear{ selectedTab = 4 }
                    .tag(4)
            }
        )
        .tint(.black)
        .onChange(
            of: selectedTab, { oldValue, newValue in
                showSheet =  selectedTab == 2
                prevIndex = oldValue
            }
        )
        .sheet(
            isPresented: $showSheet,
            onDismiss: {
                selectedTab = prevIndex
            },
            content: {
                CreateThreadView()
            }
        )
    }
}

#Preview {
    TabBarView()
}
