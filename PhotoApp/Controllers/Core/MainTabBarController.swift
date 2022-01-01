//
//  MainTabBarController.swift
//  PhotoApp
//
//  Created by Ewen on 2021/12/14.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.tag == 2 {
            let actionSheet = UIAlertController(title: "Add a Photo", message: "Select a source:", preferredStyle: .actionSheet)
            
            // Only add the camera button if it's available
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let cameraButton = UIAlertAction(title: "Camera", style: .default) { (action) in
                    self.showImagePicker(mode: .camera)
                }
                actionSheet.addAction(cameraButton)
            }
            
            // Only add the library button if it's available
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                let libraryButton = UIAlertAction(title: "Photo Library", style: .default) { (action) in
                    self.showImagePicker(mode: .photoLibrary)
                }
                actionSheet.addAction(libraryButton)
            }
            
            let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            actionSheet.addAction(cancelButton)
            
            present(actionSheet, animated: true, completion: nil)
        }
    }
    
    func showImagePicker(mode: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = mode
        imagePicker.delegate = self // Set the tab bar controller as the delegate
        present(imagePicker, animated: true, completion: nil)
    }

    func goToFeed() {
        selectedIndex = 0 // Switch tab to the first one
    }
}


// MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate
extension MainTabBarController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let selectedImage = info[.editedImage] as? UIImage
        
        if let selectedImage = selectedImage {
            let cameraVC = self.selectedViewController as? CameraViewController //重要一步
            if let cameraVC = cameraVC {
                cameraVC.savePhoto(image: selectedImage) // Upload it
            }
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
}
