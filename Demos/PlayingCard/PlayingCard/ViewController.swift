//
//  ViewController.swift
//  PlayingCard
//
//  Created by Ryan Brazones on 8/22/18.
//  Copyright © 2018 greenred. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var deck = PlayingCardDeck()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for _ in 1...10 {
            if let card = deck.draw() {
                print("\(card)")
            }
        }
        
    }
}

