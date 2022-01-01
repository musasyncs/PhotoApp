//
//  OnboardingViewController.swift
//  PhotoApp
//
//  Created by Ewen on 2022/1/1.
//

import UIKit

class OnboardingViewController: UIViewController {
    
    var slides = OnboardingSlide.collection
    var currentIndex = 0 {
        didSet {
            pageControl.currentPage = currentIndex
            if currentIndex == slides.count - 1 {
                nextBtn.setTitle("Get Started", for: .normal)
            } else {
                nextBtn.setTitle("Next", for: .normal)
            }
        }
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

}

extension OnboardingViewController {
    private func setup() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = false // isPagingEnabled 不要開啟，不然 scrollToItem 會失效
        collectionView.isScrollEnabled = false // 不可滑動，只能透過按按鈕到下一頁
        collectionView.collectionViewLayout = layout
        
        pageControl.numberOfPages = OnboardingSlide.collection.count
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension OnboardingViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return slides.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.CellID.OnboardingCollectionViewCell, for: indexPath) as! OnboardingCollectionViewCell
        cell.setup(slides[indexPath.row])
        return cell
    }
    
    // UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    // UICollectionViewDelegate
    // 圓點切換
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        currentIndex = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
}

// MARK: - Actions
extension OnboardingViewController {
    @IBAction func nextBtnClicked(_ sender: UIButton) {
        if currentIndex == slides.count - 1 {
            performSegue(withIdentifier: K.SegueID.showLogin, sender: nil)
        } else {
            currentIndex += 1
            let indexPath = IndexPath(item: currentIndex, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
}
