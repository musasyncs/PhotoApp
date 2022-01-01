//
//  Presentaion.swift
//  PhotoApp
//
//  Created by Ewen on 2021/12/28.
//

import UIKit

class Presentaion {
    static let shared = Presentaion()
    
    enum VC {
        case MainTabBarController
        case LoginViewController
    }
    
    func show(vc: VC) {
        var contoller: UIViewController
        
        switch vc {
        case .MainTabBarController:
            contoller = MainTabBarController.instantiate()
        case .LoginViewController:
            contoller = LoginViewController.instantiate()
        }
        
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate,
            let window = sceneDelegate.window {
            window.rootViewController = contoller
            UIView.transition(with: window, duration: 0.25, options: .transitionCrossDissolve, animations: nil, completion: nil)
        }
    }
}
