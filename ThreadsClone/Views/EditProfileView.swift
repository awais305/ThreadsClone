//
//  EditProfileView.swift
//  ThreadsClone
//
//  Created by Mohammad Awais on 9/20/24.
//

import SwiftUI
import PhotosUI

struct EditProfileView: View {
    let user: UserModel?
    
    @Environment(\.dismiss) var dismiss
    @Binding var isPresented: Bool
    
    @State private var bio = ""
    @State private var link = ""
    @State private var isPrivateProfile = false
    
    @State var isUploading: Bool = false
    @State var uiImage: UIImage?
    @State var profileImage: Image?
    @State var selectedImage: PhotosPickerItem?
    
    private func loadImage() async {
        guard let item = selectedImage else { return }
        guard let data = try? await item.loadTransferable(type: Data.self) else { return }
        self.uiImage = UIImage(data: data)
        self.profileImage = Image(uiImage: uiImage!)
    }
    
    private func updateProfileImage() async {
        if profileImage == nil {
            isPresented.toggle();
            return
        }
        isUploading.toggle()
        guard let image = self.uiImage else { return }
        let imageUrl = try? await ImageUploader.uploadImage(image)
        if imageUrl != nil {
            try? await UserService.instance.updateUserProfileImage(withImageUrl: imageUrl!)
            isUploading.toggle()
            isPresented.toggle()
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGroupedBackground)
                    .ignoresSafeArea(edges: [.bottom])
                VStack {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Name")
                                .fontWeight(.semibold)
                            Text(user?.fullname ?? "")
                        }
                        
                        Spacer()
                        
                        PhotosPicker(selection: $selectedImage)  {
                            if let image = profileImage {
                                image
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .clipShape(Circle())
                            } else{
                                CircularImageView(user: user, size: .small)
                            }
                        }
                        .onChange(of: selectedImage) {
                            Task{ await loadImage() }
                        }
                    }
                    
                    Divider()
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Bio")
                            .fontWeight(.semibold)
                        TextField("Add Bio", text: $bio)
                    }
                    Divider()
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Link")
                            .fontWeight(.semibold)
                        TextField("Add Link", text: $link)
                    }
                    Divider()
                    Toggle("Private Profile", isOn: $isPrivateProfile)
                }
                .font(.footnote)
                .padding()
                .background(.white)
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color(.systemGray4), lineWidth: 1)
                }
                .padding()
            }
            .onAppear() {
                bio = user?.bio ?? ""
                link = user?.profileImageUrl ?? ""
            }
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(
                    id: "cancel",
                    placement: .topBarLeading,
                    content: {
                        Button("Cancel") {
                            isPresented.toggle()
                        }
                        .font(.subheadline)
                        .foregroundStyle(.black)
                    }
                )
                ToolbarItem(
                    id: "done",
                    placement: .topBarTrailing,
                    content: {
                        if isUploading {
                            ProgressView()
                        }
                        
                        Button("Done"){
//                            if profileImage != nil {
                                Task { await updateProfileImage() }
//                            }
//                            Task { await UserService.instance.up }                            
                        }
                        .fontWeight(.semibold)
                        .font(.subheadline)
                        .foregroundStyle(.black)
                    }
                )
            }
        }
    }
}

#Preview {
    EditProfileView(
        user: DeveloperPreview.shared.user,
        isPresented: .constant(false)
    )
}
