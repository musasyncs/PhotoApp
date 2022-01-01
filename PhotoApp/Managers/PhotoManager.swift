//
//  PhotoManager.swift
//  PhotoApp
//
//  Created by Ewen on 2021/12/14.
//

import FirebaseStorage
import FirebaseFirestore

class PhotoManager {
    static let shared = PhotoManager()
    
    func savePhoto(image: UIImage, progressUpdate: @escaping (Double) -> Void ) {
        if !LocalStorage.shared.hasLogedIn { return }
        
        // Create storage path
        guard let userId = LocalStorage.shared.loadUser()?.userId else { return }
        let filename = UUID().uuidString
        let path = Storage.storage().reference().child("images/\(userId)/\(filename).jpg")
        
        guard let photoData = image.jpegData(compressionQuality: 0.1) else { return }
        
        // Upload the data
        let uploadTask = path.putData(photoData, metadata: nil) { (_, error) in
            if error == nil {
                self.createDatabaseEntry(path: path)
            }
        }
        
        // Observe progress
        uploadTask.observe(.progress) { (taskSnapshot) in
            let pct = Double(taskSnapshot.progress!.completedUnitCount) / Double(taskSnapshot.progress!.totalUnitCount)
            print(pct)
            progressUpdate(pct)
        }
    }
    
    func retrievePhotos(completion: @escaping ([Photo]) -> Void) {
        Firestore.firestore().collection("photos").getDocuments { (querySnapshot, error) in
            if let queryDocSnapshots = querySnapshot?.documents, error == nil {
                var photos = [Photo]()
                
                for queryDocSnapshot in queryDocSnapshots {
                    if let photo = Photo(snapshot: queryDocSnapshot) {
                        photos.insert(photo, at: 0)
                    }
                }
                completion(photos)
            }
        }
    }
    
    
    // helper
    private func createDatabaseEntry(path: StorageReference) {
        path.downloadURL { (url, error) in
            if let url = url, error == nil {
                let photoUser = LocalStorage.shared.loadUser()
                guard let userId = photoUser?.userId,
                      let username = photoUser?.username else { return }
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = .full

                let dic = [
                    "photoId": path.fullPath,
                    "byId": userId,
                    "byUsername": username,
                    "date": dateFormatter.string(from: Date()),
                    "urlString": url.absoluteString
                ]
                
                Firestore.firestore().collection("photos").addDocument(data: dic) { (error) in
                    if error == nil {
                        print("Successfully created database entry for the photo")
                    }
                }
            }
        }
    }
    
}
