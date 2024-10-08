//
//  ProfileHeader.swift
//  ThreadsClone
//
//  Created by Mohammad Awais on 10/1/24.
//

import SwiftUI

struct ProfileHeader: View {
    let user: UserModel?
    
    init(user: UserModel?) {
        self.user = user
    }
    
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(user?.fullname ?? "")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    Text("@" + (user?.username ?? ""))
                        .font(.subheadline)
                }
                if let bio = user?.bio {
                    Text(bio)
                        .font(.footnote)
                }
                Text("4.8M followers")
                    .font(.caption)
                    .foregroundStyle(.gray)
            }
            
            Spacer()
            
            CircularImageView(user: user, size: .medium)
        }
        .padding()
    }
}

#Preview {
    ProfileHeader(user: DeveloperPreview.shared.user)
}
