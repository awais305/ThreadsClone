//
//  ImageUploader.swift
//  ThreadsClone
//
//  Created by Mohammad Awais on 10/2/24.
//


import Foundation
import Firebase
import FirebaseStorage

struct ImageUploader {
    static func uploadImage(_ image: UIImage) async throws -> String? {
        guard let imageData = image.jpegData(compressionQuality: 0.25) else { return nil }
        let filename = NSUUID().uuidString
        let storageRef = Storage.storage().reference(withPath: "/profile_images/\(filename)")
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg" // Set content type in metadata
        
        do {
            let _ = try await storageRef.putDataAsync(imageData, metadata: metadata)
            let url = try await storageRef.downloadURL()
            return url.absoluteString
        } catch {
            print("DEBUG: Failed to upload image with error: \(error.localizedDescription)")
            return nil
        }
    }
    
//    private func uploadImage() async {
//        guard let item = selectedImage else { return }
//        guard let data = try? await item.loadTransferable(type: Data.self) else { return }
//        let url = URL(string: "https://httpbin.org/post")!
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.httpBody = data
//    }
}
