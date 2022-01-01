//
//  Extensions.swift
//  PhotoApp
//
//  Created by Ewen on 2021/12/28.
//

import UIKit

// MARK: - UIViewController extension
extension UIViewController {
    static var identifier: String {
        return String(describing: self)
    }
    
    static func instantiate() -> Self {
        return UIStoryboard(name: K.StoryboardName.Main, bundle: nil).instantiateViewController(withIdentifier: identifier) as! Self
    }
}


// MARK: - delay
func delay(durationInSeconds secound: Double, completion: @escaping () -> Void){
    DispatchQueue.main.asyncAfter(deadline: .now() + secound, execute: completion)
}
