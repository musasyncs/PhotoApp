//
//  FeedViewController.swift
//  PhotoApp
//
//  Created by Ewen on 2021/12/14.
//

import UIKit

class FeedViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var photos = [Photo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(refreshFeed(refreshControl:)), for: .valueChanged)
        self.tableView.addSubview(refresh) //cool
        
        updateUI()
    }
    
    func updateUI() {
        DispatchQueue.main.async {
            PhotoManager.shared.retrievePhotos { photos in
                self.photos = photos
                self.tableView.reloadData()
            }
        }
    }
    
    // Actions
    @objc func refreshFeed(refreshControl: UIRefreshControl) {
        updateUI()
        refreshControl.endRefreshing()
    }

}

extension FeedViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.CellID.PhotoCellId, for: indexPath) as? PhotoCell
        let photo = self.photos[indexPath.row]
        cell?.displayPhoto(photo: photo)
        return cell!
    }
}
