//
//  ImageGalleryViewController.swift
//  imageGallery
//
//  Created by Ryan Brazones on 11/13/18.
//  Copyright © 2018 greenred. All rights reserved.
//

import UIKit

class ImageGalleryViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIDropInteractionDelegate, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var galleryCollectionView: UICollectionView! {
        didSet {
            galleryCollectionView.delegate = self
            galleryCollectionView.dataSource = self
            galleryCollectionView.addInteraction(UIDropInteraction(delegate: self))
            
            // gesture recognizer
            let handler = #selector(changeCellWidthFromPinch(byReactingTo:))
            let pinchRecognizer = UIPinchGestureRecognizer(target: self, action: handler)
            galleryCollectionView.addGestureRecognizer(pinchRecognizer)
            
        }
    }
    
    @objc func changeCellWidthFromPinch(byReactingTo pinchRecognizer: UIPinchGestureRecognizer){
        switch pinchRecognizer.state {
        case .ended, .changed:
            galleryCellWidth *= pinchRecognizer.scale
            pinchRecognizer.scale = 1
        default:
            break
        }
        
        print(galleryCellWidth)
    }
    
    var galleryCellWidth: CGFloat = 200 {
        didSet {
            if galleryCollectionView != nil {
                galleryCollectionView.setNeedsLayout()
                galleryCollectionView.collectionViewLayout.invalidateLayout()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    private var imageURLS = [URL]()

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: galleryCellWidth, height: galleryCollectionView.bounds.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageURLS.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageGalleryCell", for: indexPath)
        
        let imageURL = imageURLS[indexPath.row]
        
        if let finalCell = cell as? imageGaleryCollectionViewCell {
            finalCell.imageURL = imageURL
        }

        return cell 
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: NSURL.self) && session.canLoadObjects(ofClass: UIImage.self)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        return UIDropProposal(operation: .copy)
    }
    
    var imageFetcher: ImageFetcher!
    
    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        
        imageFetcher = ImageFetcher() { (url, image) in
            DispatchQueue.main.async {
                self.imageURLS += [url]
                self.galleryCollectionView.reloadData()
            }
        }
        
        session.loadObjects(ofClass: NSURL.self, completion: {nsurls in
            if let url = nsurls.first as? URL {
                self.imageFetcher.fetch(url)
            }
        })
        
        session.loadObjects(ofClass: UIImage.self, completion: {images in
            if let image = images.first as? UIImage {
                self.imageFetcher.backup = image
            }
        })
    }

    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
