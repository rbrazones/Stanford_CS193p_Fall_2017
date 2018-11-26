//
//  imageGaleryCollectionViewCell.swift
//  imageGallery
//
//  Created by Ryan Brazones on 11/13/18.
//  Copyright © 2018 greenred. All rights reserved.
//

import UIKit

class imageGaleryCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageLoadingIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var imageView: customImageView! {
        didSet {
            adjustBounds()
        }
    }
    
    var widthToHeightRatio: CGFloat = 0
    
    override var bounds: CGRect {
        didSet {
            adjustBounds()
        }
    }
    
    // called whenever the width of the collection view
    // cell is adjusted
    private func adjustBounds() {
        if imageView != nil && imageView.backgroundImage != nil {
            
            widthToHeightRatio = imageView.backgroundImage!.size.width / imageView.backgroundImage!.size.height
            
            // if the cell exceeds the width of the image,
            // just set imageView width to image width
            if bounds.size.width >= imageView!.backgroundImage!.size.width {
                
                let tempWidth = imageView!.backgroundImage!.size.width
                let tempHeight = tempWidth / widthToHeightRatio
                let origin = CGPoint(x: bounds.midX - tempWidth / 2, y: bounds.midY - tempHeight / 2)
                imageView!.frame = CGRect(origin: origin, size: CGSize(width: tempWidth, height: tempHeight))
            }
            
            // otherwise we need to scale down the imageView
            else if (bounds.size.width < imageView!.backgroundImage!.size.width) {
                let tempWidth = bounds.size.width
                let tempHeight = bounds.size.width / widthToHeightRatio
                let origin = CGPoint(x: bounds.midX - tempWidth / 2, y: bounds.midY - tempHeight / 2)
                imageView!.frame = CGRect(origin: origin, size: CGSize(width: tempWidth, height: tempHeight))
            }
        }
    }
    
    var imageFetcher: ImageFetcher!
    
    var previousImageURL: URL!
    
    var imageURL: URL! {
        didSet {
            if imageURL != nil {
                
                // get rid of the old image if it is not what we are requesting
                // zero image view, and show the loading indicator as well
                if imageURL != previousImageURL {
                    imageView.backgroundImage = nil
                    imageLoadingIndicator.startAnimating()
                    imageLoadingIndicator.isHidden = false
                    imageView.bounds = CGRect.zero
                }
                
                imageFetcher = ImageFetcher(){ (url, image) in
                    DispatchQueue.main.async {
                        // make sure we have the correct image
                        if url == self.imageURL {
                            self.imageLoadingIndicator.stopAnimating()
                            self.imageView.backgroundImage = image
                            self.adjustBounds()
                            self.previousImageURL = url
                        } else {
                            print("image mismatch occurring")
                        }
                    }
                }
                self.imageFetcher.fetch(self.imageURL!)
            }
        }
    }
}
