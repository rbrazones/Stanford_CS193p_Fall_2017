//
//  ImageScrollViewController.swift
//  imageGallery
//
//  Created by Ryan Brazones on 12/1/18.
//  Copyright © 2018 greenred. All rights reserved.
//

import UIKit

class ImageScrollViewController: UIViewController {

    @IBOutlet weak var centerScrollViewWidth: NSLayoutConstraint!
    @IBOutlet weak var centerScrollViewHeight: NSLayoutConstraint!
    @IBOutlet weak var holdingView: UIView!
    
    var imageScrollView = ImageScrollView()
    
    var imageScrollViewURL: URL? {
        get {
            return imageScrollView.backgroundImageURL
        }
        set {
            centerScrollView?.zoomScale = 1.0
            imageScrollView.backgroundImageURL = newValue
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageScrollView.delegate = self
    }
    
    @IBOutlet weak var centerScrollView: UIScrollView! {
        didSet {
            guard centerScrollView != nil else { return }
            centerScrollView.delegate = self
            centerScrollView?.minimumZoomScale = 0.1
            centerScrollView?.maximumZoomScale = 5.0
            centerScrollView?.addSubview(imageScrollView)
        }
    }
}

extension ImageScrollViewController: SignalImageLoadedDelegate {
    func imageFinishedLoading() {
        let size = imageScrollView.image?.size ?? CGSize.zero
        imageScrollView.frame = CGRect(origin: CGPoint.zero, size: size)
        centerScrollView?.contentSize = size
        centerScrollViewWidth.constant = size.width
        centerScrollViewHeight.constant = size.height
    }
}

protocol SignalImageLoadedDelegate {
    func imageFinishedLoading()
}

extension ImageScrollViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageScrollView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        centerScrollViewWidth.constant = centerScrollView.contentSize.width
        centerScrollViewHeight.constant = centerScrollView.contentSize.height
    }
}


