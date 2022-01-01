//
//  CameraViewController.swift
//  PhotoApp
//
//  Created by Ewen on 2021/12/14.
//

import UIKit

class CameraViewController: UIViewController {

    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var doneButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        doneButton.layer.cornerRadius = 10
        // Hide and reset
        progressLabel.alpha = 0
        progressBar.alpha = 0
        progressBar.progress = 0
        doneButton.alpha = 0
    }
    
    func savePhoto(image: UIImage) {
        PhotoManager.shared.savePhoto(image: image) { (pct) in
            DispatchQueue.main.async {
                // Update the progress bar
                self.progressBar.alpha = 1
                self.progressBar.progress = Float(pct)
                
                // Update the label
                let roundedPct = Int(pct * 100)
                self.progressLabel.text = "\(roundedPct) %"
                self.progressLabel.alpha = 1
                
                // Check if it's done
                if pct == 1 {
                    self.progressLabel.text = "Upload Completed!"
                    self.doneButton.alpha = 1
                }
            }
        }
    }

    @IBAction func doneTapped(_ sender: Any) {
        let tabBarVC = self.tabBarController as? MainTabBarController
        if let tabBarVC = tabBarVC {
            tabBarVC.goToFeed() // Call go to feed
        }
    }
    
}
