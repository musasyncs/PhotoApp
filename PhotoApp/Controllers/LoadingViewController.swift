//
//  LoadingViewController.swift
//  PhotoApp
//
//  Created by Ewen on 2022/1/1.
//

import UIKit

class LoadingViewController: UIViewController {
        
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        delay(durationInSeconds: 2.0) {
            self.showInitialView()
        }
    }
    
    private func showInitialView() {
        if LocalStorage.shared.hasLogedIn {
            Presentaion.shared.show(vc: .MainTabBarController)
        } else if LocalStorage.shared.hasOnboarded {
            Presentaion.shared.show(vc: .LoginViewController)
        } else {
            performSegue(withIdentifier: K.SegueID.showOnboarding, sender: self)
        }
    }
}
