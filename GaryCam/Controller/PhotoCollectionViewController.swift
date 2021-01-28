//
//  PhotoCollectionViewController.swift
//  GaryCam
//
//  Created by 정종문 on 2021/01/27.
//

import UIKit
import Photos

class PhotoCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var photoCollectionView: UICollectionView!
    
    var imageArray = [UIImage]()
    
    override func viewDidLoad() {
        photoCollectionView.delegate = self
        photoCollectionView.dataSource = self
        setCollectionViewLayout()
        getPhotos()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoLibraryCell", for: indexPath)
        let imageView = cell.viewWithTag(1) as! UIImageView
        
        imageView.image = imageArray[indexPath.row]
        return cell
    }
    
    func setCollectionViewLayout() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 5
        
        let width = photoCollectionView.frame.width / 3.5
        layout.itemSize = CGSize(width: width, height: width)
        
        photoCollectionView.collectionViewLayout = layout
    }

    func getPhotos() {
        let manager = PHImageManager.default()
        
        let options = PHImageRequestOptions()
        options.isSynchronous = true
        options.deliveryMode = .opportunistic
                
        let fetchResult: PHFetchResult = PHAsset.fetchAssets(with: .image, options: nil)
        
        if fetchResult.count > 0 {
            for i in 0..<fetchResult.count {
                manager.requestImage(for: fetchResult.object(at: i), targetSize: CGSize(width: 200, height: 200), contentMode: .aspectFill, options: options) {
                    (image, error) in
                    self.imageArray.append(image!)
                }
            }
            imageArray.reverse()
            
            DispatchQueue.main.async {
                self.photoCollectionView.reloadData()
            }
        } else {
            print("You got no photos!")
        }
    }
}
