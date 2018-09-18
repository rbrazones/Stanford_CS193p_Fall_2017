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
        updateViewFromModel()
    }
    
    private var gameModel = setGameModel()
    
    @IBOutlet weak var setCardGridView: SetCardGridView!
    
    private var mapGameCardToSetCardViews = Dictionary<Int, SetCardView>()
    
}

extension SetViewController {
    
    private func updateViewFromModel() {
        for card in gameModel.currentCards {
            if !mapGameCardToSetCardViews.keys.contains(card) {
                let newCardView = SetCardView()
                newCardView.shape = constantValues.cardShapes[gameModel.gameCards[card].shape]!
                newCardView.shade = constantValues.cardShades[gameModel.gameCards[card].shade]!
                newCardView.number = constantValues.cardNumbers[gameModel.gameCards[card].number]!
                mapGameCardToSetCardViews[card] = newCardView
                setCardGridView.currentCards += [newCardView]
            }
        }
    }
    
    // constant for drawing cards
    private struct constantValues {
        static let cardShapes = [setCard.shapeOptions.shapeA: SetCardView.withShape.oval,
                                 setCard.shapeOptions.shapeB: SetCardView.withShape.diamond,
                                 setCard.shapeOptions.shapeC: SetCardView.withShape.squiggle]
        static let cardNumbers = [setCard.numberOptions.numberA: 1,
                                  setCard.numberOptions.numberB: 2,
                                  setCard.numberOptions.numberC: 3]
        static let cardColors = [setCard.colorOptions.colorA: UIColor.red,
                                 setCard.colorOptions.colorB: UIColor.purple,
                                 setCard.colorOptions.colorC: UIColor.green]
        static let cardShades = [setCard.shadeOptions.shadeA: SetCardView.withShade.solid,
                                 setCard.shadeOptions.shadeB: SetCardView.withShade.striped,
                                 setCard.shadeOptions.shadeC: SetCardView.withShade.unfilled]
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

