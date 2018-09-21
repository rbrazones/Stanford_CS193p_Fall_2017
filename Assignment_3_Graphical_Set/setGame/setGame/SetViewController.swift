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
        setCardGridView.delegate = self
    }
    
    
    
    private var gameModel = setGameModel()
    
    @IBOutlet weak var setCardGridView: SetCardGridView!
    
    @IBAction func touchDeal3CardsButton(_ sender: UIButton) {
        gameModel.dealMoreCards()
        updateViewFromModel()
    }
    private var mapGameCardToSetCardViews = Dictionary<Int, SetCardView>()
}

extension SetViewController: TouchSetCardDelegate {
    func touchedSetCard(with currentCardIndex: Int) {
        print("inside the TOP DOG with cardIndex = \(currentCardIndex)")
        let card = setCardGridView.currentCards[currentCardIndex]
        let mapGameCardIndex = mapGameCardToSetCardViews.keysForValues(value: card)
        for cardIndex in mapGameCardIndex {
            if gameModel.selectedCards.count == 3 && !gameModel.selectedCards.contains(cardIndex) {
                return // do nothing
            } else {
                gameModel.attemptToSelect(on: cardIndex)
            }
        }
        updateViewFromModel()
    }
}

extension SetViewController {
    
    private func updateViewFromModel() {
        
        for card in gameModel.currentCards {
            if !mapGameCardToSetCardViews.keys.contains(card) {
                let newCardView = SetCardView()
                newCardView.shape = constantValues.cardShapes[gameModel.gameCards[card].shape]!
                newCardView.shade = constantValues.cardShades[gameModel.gameCards[card].shade]!
                newCardView.color = constantValues.cardColors[gameModel.gameCards[card].color]!
                newCardView.number = constantValues.cardNumbers[gameModel.gameCards[card].number]!
                mapGameCardToSetCardViews[card] = newCardView
                setCardGridView.currentCards += [newCardView]
            }
            if gameModel.selectedCards.contains(card){
                mapGameCardToSetCardViews[card]!.isSelected = true
            } else {
                mapGameCardToSetCardViews[card]!.isSelected = false
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

protocol TouchSetCardDelegate {
    func touchedSetCard(with currentCardIndex: Int)
}

