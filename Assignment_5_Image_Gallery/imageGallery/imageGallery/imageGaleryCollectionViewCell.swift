//
//  imageGaleryCollectionViewCell.swift
//  imageGallery
//
//  Created by Ryan Brazones on 11/13/18.
//  Copyright © 2018 greenred. All rights reserved.
//

import UIKit

class imageGaleryCollectionViewCell: UICollectionViewCell {
    /*
    @IBOutlet weak var imageView: UIImageView! {
        didSet {
            print("didSet imageView")
            adjustBounds()
        }
    }
    */
    @IBOutlet weak var imageLoadingIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var imageView: customImageView! {
        didSet {
            adjustBounds()
        }
    }
    
    var widthToHeightRatio: CGFloat = 0
    
    override var bounds: CGRect {
        didSet {
            
            print("bounds change - CELL")
            
            adjustBounds()
        }
    }
    
    // called whenever the width of the collection view
    // cell is adjusted
    private func adjustBounds() {
        if imageView != nil && imageView.backgroundImage != nil {
            
            print("adjustBounds()")
            
            widthToHeightRatio = imageView.backgroundImage!.size.width / imageView.backgroundImage!.size.height
            
            print("widthheighratio = \(widthToHeightRatio)")
            
            // if the cell exceeds the width of the image,
            // just set imageView width to image width
            if bounds.size.width >= imageView!.backgroundImage!.size.width {
                
                let tempWidth = imageView!.backgroundImage!.size.width
                let tempHeight = tempWidth / widthToHeightRatio
                let origin = CGPoint(x: bounds.midX - tempWidth / 2, y: bounds.midY - tempHeight / 2)
                imageView!.frame = CGRect(origin: origin, size: CGSize(width: tempWidth, height: tempHeight))
                
                //imageView!.bounds.size.width = imageView.backgroundImage!.size.width
                //imageView!.bounds.size.height = imageView.backgroundImage!.size.height // this needs to be better
            }
            
            // otherwise we need to scale down the imageView
            else if (bounds.size.width < imageView!.backgroundImage!.size.width) {
                let tempWidth = bounds.size.width
                let tempHeight = bounds.size.width / widthToHeightRatio
                let origin = CGPoint(x: bounds.midX - tempWidth / 2, y: bounds.midY - tempHeight / 2)
                imageView!.frame = CGRect(origin: origin, size: CGSize(width: tempWidth, height: tempHeight))
            }
            
        }
        //setNeedsLayout()
    }
    
    var imageFetcher: ImageFetcher!
    
    var imageURL: URL! {
        didSet {
            if imageURL != nil {
                imageFetcher = ImageFetcher(){ (url, image) in
                    DispatchQueue.main.async {
                        self.imageLoadingIndicator.stopAnimating()
                        self.imageView.backgroundImage = image
                        self.adjustBounds()
                    }
                }
                self.imageFetcher.fetch(self.imageURL!)
            }
        }
    }
}
