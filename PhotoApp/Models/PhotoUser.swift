//
//  PhotoUser.swift
//  PhotoApp
//
//  Created by Ewen on 2021/12/14.
//


struct PhotoUser {
    var userId: String?
    var username: String?
    
    init(userId: String?, username: String?) {
        self.userId = userId
        self.username = username
    }
    
    init(dic: [String: Any]) {
        self.userId = dic["userId"] as? String
        self.username = dic["username"] as? String
    }
}
