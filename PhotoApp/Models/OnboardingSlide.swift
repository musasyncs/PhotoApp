//
//  OnboardingSlide.swift
//  PhotoApp
//
//  Created by Ewen on 2021/12/28.
//

import UIKit

struct OnboardingSlide {
    let title: String
    let description: String
    let image: UIImage
    
    static let collection: [OnboardingSlide] = [
        OnboardingSlide(
            title: "啟動頁、導覽頁",
            description: "跳轉邏輯 / Collection View Scroll",
            image: #imageLiteral(resourceName: "slide1")
        ),
        OnboardingSlide(
            title: "註冊、登入、登出功能",
            description: "有效信箱密碼檢查 / FirebaseAuth / FirebaseFirestore",
            image: #imageLiteral(resourceName: "slide2")
        ),
        OnboardingSlide(
            title: "照片雲端存取",
            description: "UIImagePickerController / FirebaseStorage / FirebaseFirestore",
            image: #imageLiteral(resourceName: "slide3")
        )
    ]
}
