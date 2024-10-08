//
//  UserProfileView.swift
//  ThreadsClone
//
//  Created by Mohammad Awais on 9/30/24.
//

import SwiftUI

struct UserProfileView: View {
    let user: UserModel?
    
    var body: some View {
        ScrollView {
            VStack {
                ProfileHeader(user: user)
                
                Button {
                    
                } label: {
                    Text("Follow")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                        .frame(width: 352, height: 32)
                        .background(.black)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                
                ProfileContentSection(uid: user?.id)

            }
        }
//        .navigationBarTitleDisplayMode(.inline)
//        .padding(.horizontal)
    }
}

#Preview {
    UserProfileView(user: DeveloperPreview.shared.user)
}
