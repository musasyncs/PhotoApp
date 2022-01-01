//
//  LocalStorage.swift
//  PhotoApp
//
//  Created by Ewen on 2021/12/28.
//

import Foundation

class LocalStorage {
    static let shared = LocalStorage()
        
    // hasLogedIn
    var hasLogedIn: Bool {
        get {
            UserDefaults.standard.bool(forKey: K.LocalStorageKey.hasLogedIn)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: K.LocalStorageKey.hasLogedIn)
        }
    }
    
    // hasOnboarded
    var hasOnboarded: Bool {
        get {
            UserDefaults.standard.bool(forKey: K.LocalStorageKey.hasOnboarded)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: K.LocalStorageKey.hasOnboarded)
        }
    }
     
    // saveUser / loadUser / clearUser
    func saveUser(userId: String?, username: String?) {
        UserDefaults.standard.set(userId, forKey: K.LocalStorageKey.userIdKey)
        UserDefaults.standard.set(username, forKey: K.LocalStorageKey.usernameKey)
    }
    
    func loadUser() -> PhotoUser? {
        let userId = UserDefaults.standard.value(forKey: K.LocalStorageKey.userIdKey) as? String
        let username = UserDefaults.standard.value(forKey: K.LocalStorageKey.usernameKey) as? String
        return PhotoUser(userId: userId, username: username)
    }
    
    func clearUser() {
        UserDefaults.standard.set(nil, forKey: K.LocalStorageKey.userIdKey)
        UserDefaults.standard.set(nil, forKey: K.LocalStorageKey.usernameKey)
    }
    
}
