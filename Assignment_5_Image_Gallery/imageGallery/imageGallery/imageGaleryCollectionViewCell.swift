//
//  imageGaleryCollectionViewCell.swift
//  imageGallery
//
//  Created by Ryan Brazones on 11/13/18.
//  Copyright © 2018 greenred. All rights reserved.
//

import UIKit

class imageGaleryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var imageFetcher: ImageFetcher!
    
    var imageURL: URL! {
        didSet {
            if imageURL != nil {
                imageFetcher = ImageFetcher(){ (url, image) in
                    DispatchQueue.main.async {
                        self.imageView.image = image
                    }
                }
                self.imageFetcher.fetch(self.imageURL!)
            }
        }
    }
}
