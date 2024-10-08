//
//  ContentView.swift
//  ThreadsClone
//
//  Created by Mohammad Awais on 9/17/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var contentViewModel = ContentViewModel()
    
    var body: some View {
        Group {
            if contentViewModel.userSession == nil {
                LoginView()
            } else {
                TabBarView()
            }
        }
    }
}

#Preview {
    ContentView()
}
