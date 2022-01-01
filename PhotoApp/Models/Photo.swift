//
//  Photo.swift
//  PhotoApp
//
//  Created by Ewen on 2021/12/14.
//

import FirebaseFirestore

struct Photo {
    var photoId: String?
    var byId: String?
    var byUsername: String?
    var date: String?
    var urlString: String?
    
    init?(snapshot: QueryDocumentSnapshot) {
        let dic = snapshot.data()
    
        let photoId     = dic["photoId"] as? String
        let userId      = dic["byId"] as? String
        let username    = dic["byUsername"] as? String
        let date        = dic["date"] as? String
        let urlString   = dic["urlString"] as? String
        
        // 若至少一個參數為 nil，則 Photo 為 nil
        guard let photoId = photoId, let userId = userId, let username = username, let date = date, let urlString = urlString else { return nil }
        
        self.photoId = photoId
        self.byId = userId
        self.byUsername = username
        self.date = date
        self.urlString = urlString
    }
}
