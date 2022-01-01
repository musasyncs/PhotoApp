//
//  PhotoCell.swift
//  PhotoApp
//
//  Created by Ewen on 2021/12/14.
//

import UIKit

class PhotoCell: UITableViewCell {
    var photo: Photo?

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    
    func displayPhoto(photo: Photo) {
        self.photoImageView.image = nil
        
        self.photo = photo
        
        usernameLabel.text = photo.byUsername
        dateLabel.text = photo.date
        
        /// Check if the image is in our image cache, if it is, use it
        guard let urlString = photo.urlString else { return }
        if let cachedImage = ImageCache.shared.getImage(urlString) {
            self.photoImageView.image = cachedImage
            return
        }
        
        /// Otherwise, download the image
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let data = data, let image = UIImage(data: data), error == nil {
                
                /// Store the image in cache
                ImageCache.shared.saveImage(url.absoluteString, image)
                
                guard url.absoluteString == self.photo?.urlString else { return } //!!!
                
                DispatchQueue.main.async {
                    self.photoImageView.image = image
                }
            }
        }.resume()
    }

}
