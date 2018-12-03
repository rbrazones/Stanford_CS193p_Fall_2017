//
//  ImageGalleryViewController.swift
//  imageGallery
//
//  Created by Ryan Brazones on 11/13/18.
//  Copyright © 2018 greenred. All rights reserved.
//

import UIKit

class ImageGalleryViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDragDelegate, UICollectionViewDropDelegate {

    let layout = UICollectionViewFlowLayout()
    
    @IBOutlet weak var galleryCollectionView: UICollectionView! {
        didSet {
            galleryCollectionView.delegate = self
            galleryCollectionView.dataSource = self
            galleryCollectionView.dragDelegate = self
            galleryCollectionView.dropDelegate = self
            
            layout.estimatedItemSize = CGSize(width: galleryCellWidth, height: galleryCollectionView.bounds.size.height)
            
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
        galleryCollectionView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapOnCell)))
    }

    @objc private func handleTapOnCell(sender: UITapGestureRecognizer) {
        guard let indexPath = self.galleryCollectionView?.indexPathForItem(at: sender.location(in: self.galleryCollectionView)) else { return }
        guard let cell = galleryCollectionView?.cellForItem(at: indexPath) else { return }
        guard let finalCell = cell as? imageGaleryCollectionViewCell else { return }
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        guard let destinationViewController = mainStoryboard.instantiateViewController(withIdentifier: "ImageScrollViewController") as? ImageScrollViewController else { return }
        destinationViewController.imageScrollViewURL = finalCell.imageURL
        navigationController?.pushViewController(destinationViewController, animated: true)
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
    
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        session.localContext = collectionView // lets you know this is a local drag, and here is the context
        return dragItems(at: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, itemsForAddingTo session: UIDragSession, at indexPath: IndexPath, point: CGPoint) -> [UIDragItem] {
        return dragItems(at: indexPath)
    }

    private func dragItems(at indexPath: IndexPath) -> [UIDragItem] {
        
        guard let cell = galleryCollectionView.cellForItem(at: indexPath) as? imageGaleryCollectionViewCell else {
            return []
        }

        guard let dragURL = cell.imageURL else {
            return []
        }
        
        let dragItem = UIDragItem(itemProvider: NSItemProvider(object: dragURL as NSURL))
        dragItem.localObject = dragURL
        return [dragItem]
    }
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        // coordinator will give us a lot of information -- destinationIndexPath
        let destinationIndexPath = coordinator.destinationIndexPath ?? IndexPath(item: 0, section: 0)
        for item in coordinator.items {
            
            // check if this is coming from myself
            // the local case
            if let sourceIndexPath = item.sourceIndexPath {
                if let imageURL = item.dragItem.localObject as? URL{
                    collectionView.performBatchUpdates({
                        imageURLS.remove(at: sourceIndexPath.item)
                        imageURLS.insert(imageURL, at: destinationIndexPath.item)
                        collectionView.deleteItems(at: [sourceIndexPath])
                        collectionView.insertItems(at: [destinationIndexPath])
                    }, completion: nil)
                }
                coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
            } else {
                
                // grab a placeholder cell
                let dropPlaceholderCell = UICollectionViewDropPlaceholder(insertionIndexPath: destinationIndexPath, reuseIdentifier: "imagePlaceholderCell")
                
                // configure the cell
                // this doesn't work right now, I'm not going to spend more time on this for now . . .
                dropPlaceholderCell.previewParametersProvider = { (cell) in
                    guard let placeholderCell = cell as? placeholderCollectionViewCell else {return nil}
                    placeholderCell.bounds.size = CGSize(width: self.galleryCellWidth, height: self.galleryCollectionView.bounds.size.height)
                    return UIDragPreviewParameters()
                }
                
                let placeholderContext = coordinator.drop(item.dragItem, to: dropPlaceholderCell)

                item.dragItem.itemProvider.loadObject(ofClass: NSURL.self) { (provider, error) in
                    DispatchQueue.main.async {
                        if let theURL = provider as? URL {
                            placeholderContext.commitInsertion(dataSourceUpdates: { insertionIndexPath in
                                self.imageURLS.insert(theURL, at: insertionIndexPath.item)
                            })
                        } else {
                            placeholderContext.deletePlaceholder()
                        }
                    }
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {   
        if session.localDragSession != nil {
            return session.canLoadObjects(ofClass: NSURL.self)
        } else {
            return session.canLoadObjects(ofClass: NSURL.self) && session.canLoadObjects(ofClass: UIImage.self)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        let isSelf = (session.localDragSession?.localContext as? UICollectionView) == collectionView
        return UICollectionViewDropProposal(operation: isSelf ? .move : .copy, intent: .insertAtDestinationIndexPath)
    }
    
    var imageFetcher: ImageFetcher!
}
