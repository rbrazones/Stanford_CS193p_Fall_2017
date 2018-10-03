//
//  CassiniViewController.swift
//  Cassini
//
//  Created by Ryan Brazones on 10/2/18.
//  Copyright © 2018 greenred. All rights reserved.
//

import UIKit

class CassiniViewController: UIViewController {


    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            if let url = DemoURL.NASA[identifier] {
                if let imageVC = segue.destination as? ImageViewController {
                    imageVC.imageURL = url
                    imageVC.title = (sender as? UIButton)?.currentTitle
                }
            }
        }
    }
}

// used for 'unwrapping' Navigation view controller
extension UIViewController {
    var contents: UIViewController {
        if let navcon = self as? UINavigationController {
            return navcon.visibleViewController ?? self
        } else {
            return self
        }
    }
}
