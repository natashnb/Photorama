//
//  PhotosViewController.swift
//  Photorama
//
//  Created by Natash Bangera on 29/7/16.
//  Copyright © 2016 Natash Bangera. All rights reserved.
//

import UIKit

class PhotosViewController: UIViewController, UICollectionViewDelegate {
    
    @IBOutlet var collectionView: UICollectionView!
    var store: PhotoStore!
    let photoDataSource = PhotoDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = photoDataSource
        collectionView.delegate = self
        
        store.fetchRecentPhotos() {
            (photosResult) -> Void in
            
            /*
            switch photosResult {
            case let .Success(photos): print("Successfully found \(photos.count) recent photos.")
            if let firstPhoto = photos.first {
                self.store.fetchImageForPhoto(firstPhoto) {
                    (imageResult) -> Void in
                    
                        switch imageResult {
                        case let .Success(image): NSOperationQueue.mainQueue().addOperationWithBlock( {
                            self.imageView.image = image
                        })
                        case let .Failure(error): print("Error downloading image: \(error)")
                        }
                    }
                }
            case let .Failure(error): print("Error fetching recent photos: \(error)")
            } */
            
            /*
            NSOperationQueue.mainQueue().addOperationWithBlock() {
                
                switch photosResult {
                
                case let .Success(photos):
                    print("Successfully found \(photos.count) recent photos.")
                    self.photoDataSource.photos = photos
                
                case let .Failure(error):
                    self.photoDataSource.photos.removeAll()
                    print("Error fetching recent photos: \(error)")
                }
                self.collectionView.reloadSections(NSIndexSet(index: 0))
            }
            */
            
            let sortByDateTaken = NSSortDescriptor(key: "dateTaken", ascending: true)
            let allPhotos = try! self.store.fetchMainQueuePhotos(predicate: nil, sortDescriptors: [sortByDateTaken])
            
            NSOperationQueue.mainQueue().addOperationWithBlock() {
                self.photoDataSource.photos = allPhotos
                self.collectionView.reloadSections(NSIndexSet(index: 0))
            }
        }
    }
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        
        let photo = photoDataSource.photos[indexPath.row]
        
        // Download the image data, which could take some time
        store.fetchImageForPhoto(photo) { (result) -> Void in
            NSOperationQueue.mainQueue().addOperationWithBlock() {
                // The index path for the photo might have changed between the time the request started and finished,
                // so find the most recent path index
                
                let photoIndex = self.photoDataSource.photos.indexOf(photo)!
                let photoIndexPath = NSIndexPath(forRow: photoIndex, inSection: 0)
                
                // When the request finishes, only update cell if it's still visible
                if let cell = self.collectionView.cellForItemAtIndexPath(photoIndexPath) as? PhotoCollectionViewCell { cell.updateWithImage(photo.image)
                }
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowPhoto" {
            if let selectedIndexPath = collectionView.indexPathsForSelectedItems()?.first {
                let photo = photoDataSource.photos[selectedIndexPath.row]
                let destinationVC = segue.destinationViewController as! PhotoInfoViewController
                destinationVC.photo = photo
                destinationVC.store = store
            }
        }
    }
}
