//
//  imageGaleryCollectionViewCell.swift
//  imageGallery
//
//  Created by Ryan Brazones on 11/13/18.
//  Copyright © 2018 greenred. All rights reserved.
//

import UIKit

class imageGaleryCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView! {
        didSet {
            print("didSet imageView")
            adjustBounds()
        }
    }
    
    var widthToHeightRatio: CGFloat = 0
    /*
    var cellWidth: CGFloat = 80 {
        didSet {
            if imageView != nil {
                adjustBounds()
            }
        }
    }
    */
    
    override var bounds: CGRect {
        didSet {
            adjustBounds()
        }
    }
    
    // called whenever the width of the collection view
    // cell is adjusted
    private func adjustBounds() {
        if imageView != nil && imageView.image != nil {
            
            print("adjustBounds()")
            
            widthToHeightRatio = imageView.image!.size.width / imageView.image!.size.height
            
            // if the cell exceeds the width of the image,
            // just set imageView width to image width
            if bounds.size.width >= imageView!.image!.size.width {
                print("were fine")
                imageView!.bounds.size.width = imageView.image!.size.width
                imageView!.bounds.size.height = imageView.image!.size.height // this needs to be better
            }
            
            // otherwise we need to scale down the imageView
            else if (bounds.size.width < imageView!.image!.size.width) {
                print("needs to adjust")
                imageView!.bounds.size.width = bounds.size.width
                imageView!.bounds.size.height = bounds.size.width / widthToHeightRatio
            }
            
        }
    }
    
    var imageFetcher: ImageFetcher!
    
    var imageURL: URL! {
        didSet {
            if imageURL != nil {
                imageFetcher = ImageFetcher(){ (url, image) in
                    DispatchQueue.main.async {
                        self.imageView.image = image
                        
                        print("image width = \(image.size.width)")
                        print("image height = \(image.size.height)")
                        print("imageview width = \(self.imageView.bounds.size.width)")
                        print("imageview height = \(self.imageView.bounds.size.height)")
                        print("bounds width = \(self.bounds.size.width)")
                        print("bounds height = \(self.bounds.size.height)")
                        
                        
                        self.adjustBounds()
                    }
                }
                self.imageFetcher.fetch(self.imageURL!)
            }
        }
    }
}
