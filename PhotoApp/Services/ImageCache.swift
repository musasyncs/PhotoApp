//
//  ImageCache.swift
//  PhotoApp
//
//  Created by Ewen on 2021/12/14.
//

import UIKit

class ImageCache {
    static let shared = ImageCache()
    
    var imageCache = [String: UIImage]()
    
    func saveImage(_ urlString: String?, _ image: UIImage?) {
        guard let urlString = urlString, let image = image else { return }
        imageCache[urlString] = image
    }
    
    func getImage(_ urlString: String?) -> UIImage? {
        guard let urlString = urlString else { return nil }
        return imageCache[urlString]
    }
}
