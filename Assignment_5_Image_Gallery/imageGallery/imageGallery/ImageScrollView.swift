//
//  imageScrollView.swift
//  imageGallery
//
//  Created by Ryan Brazones on 12/2/18.
//  Copyright © 2018 greenred. All rights reserved.
//

import UIKit

class ImageScrollView: UIView {
    
    var delegate: SignalImageLoadedDelegate?
    
    private(set) var image: UIImage? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        image?.draw(in: bounds)
    }
    
    var imageFetcher: ImageFetcher!
    
    var backgroundImageURL: URL! {
        didSet {
            guard backgroundImageURL != nil else { return }
            imageFetcher = ImageFetcher(){ (url, image) in
                DispatchQueue.main.async {
                    if url == self.backgroundImageURL {
                        self.image = image
                        self.delegate?.imageFinishedLoading()
                    }
                    else { print("image mismatch occurring") }
                }
            }
            self.imageFetcher.fetch(self.backgroundImageURL!)
        }
    }
}
