//
//  EmojiArtView.swift
//  EmojiArt
//
//  Created by Ryan Brazones on 10/6/18.
//  Copyright © 2018 greenred. All rights reserved.
//

import UIKit

class EmojiArtView: UIView {

    var backgroundImage: UIImage? { didSet {setNeedsDisplay()} }
    
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        backgroundImage?.draw(in: bounds)
    }
 

}
