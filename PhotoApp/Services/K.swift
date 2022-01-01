//
//  K.swift
//  PhotoApp
//
//  Created by Ewen on 2021/12/28.
//

struct K {
    struct SegueID {
        static let showOnboarding = "showOnboarding"
        static let showLogin = "showLogin"
    }
    
    struct StoryboardName {
        static let Main = "Main"
    }
    
    struct CellID {
        static let PhotoCellId = "PhotoCell"
        static let OnboardingCollectionViewCell = "OnboardingCollectionViewCell"
    }
    
    struct LocalStorageKey {
        static let userIdKey = "storedUserId"
        static let usernameKey = "storedUsername"
        
        static let hasLogedIn = "hasLogedIn"
        
        static let hasOnboarded = "hasOnboarded"
    }
}
