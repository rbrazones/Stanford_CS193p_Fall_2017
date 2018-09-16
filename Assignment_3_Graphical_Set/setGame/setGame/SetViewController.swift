//
//  ViewController.swift
//  setGame
//
//  Created by Ryan Brazones on 9/3/18.
//  Copyright © 2018 greenred. All rights reserved.
//

import UIKit

class SetViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // constant for drawing cards
    private struct constantValues {
        static let cardShapes = [setCard.shapeOptions.shapeA: "▲" ,
                                 setCard.shapeOptions.shapeB: "●",
                                 setCard.shapeOptions.shapeC: "■"]
        static let cardNumbers = [setCard.numberOptions.numberA: 1,
                                  setCard.numberOptions.numberB: 2,
                                  setCard.numberOptions.numberC: 3]
        static let cardColors = [setCard.colorOptions.colorA: #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1),
                                 setCard.colorOptions.colorB: #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1),
                                 setCard.colorOptions.colorC: #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1)]
        static let cardShades = [setCard.shadeOptions.shadeA: "filled",
                                 setCard.shadeOptions.shadeB: "striped",
                                 setCard.shadeOptions.shadeC: "open"]
    }
}

// https://ijoshsmith.com/2016/04/14/find-keys-by-value-in-swift-dictionary/
extension Dictionary where Value: Equatable {
    func keysForValues(value: Value) -> [Key] {
        return compactMap {(key: Key, val: Value) -> Key? in
            value == val ? key : nil
        }
    }
}

