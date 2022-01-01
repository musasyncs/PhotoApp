//
//  SettingsViewController.swift
//  PhotoApp
//
//  Created by Ewen on 2021/12/14.
//

import UIKit
import MBProgressHUD

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var signoutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signoutButton.layer.cornerRadius = 10
    }
    
    // MARK: - Logout Check
    @IBAction func signOutTapped(_ sender: Any) {
        MBProgressHUD.showAdded(to: view, animated: true)
        delay(durationInSeconds: 0.5) { [weak self] in
            guard let self = self else { return }
            
            let result = AuthManager.shared.logoutUser()
            switch result {
            case .success:
                /// Clear local storage
                LocalStorage.shared.clearUser()
                LocalStorage.shared.hasLogedIn = false
                ///
                Presentaion.shared.show(vc: .LoginViewController)
                MBProgressHUD.hide(for: self.view, animated: true)
            case .failure(let error):
                print("登出失敗", error.localizedDescription)
            }
        }
    }

}
