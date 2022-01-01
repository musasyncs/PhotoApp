//
//  UserManager.swift
//  PhotoApp
//
//  Created by Ewen on 2021/12/14.
//

import FirebaseFirestore

class UserManager {
    static let shared = UserManager()
        
    func createProfile(userId: String, username: String, completion: @escaping (PhotoUser?) -> Void) {
        var dic = [String: Any]()
        dic["userId"] = userId
        dic["username"] = username
        
        Firestore.firestore().collection("users").document(userId).setData(dic) { (error) in
            if error == nil {
                let u = PhotoUser(dic: dic)
                completion(u)
            } else {
                completion(nil)
            }
        }
    }
    
    func retrieveProfile(userId: String, completion: @escaping (PhotoUser?) -> Void) {
        Firestore.firestore().collection("users").document(userId).getDocument { (docSnapshot, error) in
            if let dic = docSnapshot?.data(), error == nil {
                let u = PhotoUser(dic: dic)
                completion(u)
            } else {
                completion(nil)
            }
        }
    }
}
