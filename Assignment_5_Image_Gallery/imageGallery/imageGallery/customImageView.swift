//
//  customImageView.swift
//  imageGallery
//
//  Created by Ryan Brazones on 12/2/18.
//  Copyright © 2018 greenred. All rights reserved.
//

import UIKit

class customImageView: UIView {
    
    var backgroundImage: UIImage? {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override var bounds: CGRect {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        print("draw() - customImageView")
        backgroundImage?.draw(in: bounds)
    }
    
    
}
