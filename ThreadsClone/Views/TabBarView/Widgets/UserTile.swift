//
//  UserTile.swift
//  ThreadsClone
//
//  Created by Mohammad Awais on 9/29/24.
//

import SwiftUI

struct UserTile: View {
    let user: UserModel
    
    var body: some View {
        VStack {
            HStack(alignment: .top) {
                CircularImageView(user: user, size: .small)
                VStack(
                    alignment: .leading,
                    content: {
                        Text("@" + user.username)
                            .fontWeight(.semibold)
                        
                        Text(user.fullname)
                    }
                )
                .font(.footnote)
                .foregroundStyle(.black)
                Spacer()
                Button{
                    // print("user at index \(index)")
                } label: {
                    Text("Follow")
                        .foregroundColor(.black)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .frame(width: 100, height: 32)
                        .overlay {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color(.systemGray4), lineWidth: 1)
                        }
                }
                .padding(.top, 6)
            }
            Divider()
        }
    }
}

#Preview {
    UserTile(user: DeveloperPreview.shared.user)
}
