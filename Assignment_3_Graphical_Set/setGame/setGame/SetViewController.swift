//
//  ViewController.swift
//  setGame
//
//  Created by Ryan Brazones on 9/3/18.
//  Copyright © 2018 greenred. All rights reserved.
//

import UIKit

class SetViewController: UIViewController {
    
    private var gameModel = setGameModel()
    
    @IBOutlet weak var setCardGridView: SetCardGridView! {
        didSet {
            let swipeDownRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipDown(byReactingTo:)))
            swipeDownRecognizer.direction = .down
            setCardGridView.addGestureRecognizer(swipeDownRecognizer)
            
            let rotateRecognizer = UIRotationGestureRecognizer(target: self, action: #selector(handleRotationGesture(byReactingTo:)))
            setCardGridView.addGestureRecognizer(rotateRecognizer)
        }
    }
    
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var dealCardsButton: UIButton!
    @IBOutlet weak var MatchCardsButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViewFromModel()
        setCardGridView.delegate = self
        
        MatchCardsButton.layer.borderWidth = 2.0
        MatchCardsButton.layer.borderColor = constantValues.buttonOutlineColor.cgColor
        MatchCardsButton.layer.cornerRadius = 8.0
        dealCardsButton.layer.borderWidth = 2.0
        dealCardsButton.layer.borderColor = constantValues.buttonOutlineColor.cgColor
        dealCardsButton.layer.cornerRadius = 8.0
    }
    
    @IBAction func touchMatchCardsButton(_ sender: UIButton) {
        if gameModel.checkIfCardsMatched() {
            for card in setCardGridView.currentCards {
                let removeKeys = mapGameCardToSetCardViews.keysForValues(value: card)
                for key in removeKeys {
                    mapGameCardToSetCardViews.removeValue(forKey: key)
                }
                //let removeIndex = setCardGridView.currentCards.index(of: card)!
                //setCardGridView.currentCards.remove(at: removeIndex)
                setCardGridView.removeCard(card: card)
            }
            gameModel.clearMatchedCards()
            updateViewFromModel()
        }
    }
    
    @IBAction func touchDeal3CardsButton(_ sender: UIButton) {
        gameModel.dealMoreCards()
        updateViewFromModel()
    }
    
    @objc func handleSwipDown(byReactingTo swipeRecognizer: UISwipeGestureRecognizer){
        if swipeRecognizer.state == .ended {
            gameModel.dealMoreCards()
            updateViewFromModel()
        }
    }
    
    @objc func handleRotationGesture(byReactingTo rotationRecgonizer: UIRotationGestureRecognizer){
        if rotationRecgonizer.state == .ended {
            print("rotation gesture ended")
            setCardGridView.shuffleCards()
        }
    }
    
    private var mapGameCardToSetCardViews = Dictionary<Int, SetCardView>()
}

extension SetViewController: TouchSetCardDelegate {
    func touchedSetCard(with currentCardIndex: Int) {
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
        
        func determineMatchButtonStatus() {
            if gameModel.selectedCards.count == 3 {
                // enable the button
                MatchCardsButton.layer.backgroundColor = constantValues.matchButtonColor.withAlphaComponent(1.00).cgColor
                MatchCardsButton.isEnabled = true
            } else {
                // disable the button/Users/ryan/Desktop/Stanford_CS193p_Fall_2017/Assignment_4_Animated_Set/setGame_concentrationGame_combined/setGame/ViewController.swift
                MatchCardsButton.layer.backgroundColor = constantValues.matchButtonColor.withAlphaComponent(0.5).cgColor
                MatchCardsButton.isEnabled = false
            }
        }
        
        func updateScore() {
            scoreLabel.text = "Score: \(gameModel.score)"
        }
        
        func determineDealButtonStatus(){
            if gameModel.availableCards.count >= 3 {
                // enable the button
                dealCardsButton.layer.backgroundColor = constantValues.dealCardsButtonColor.withAlphaComponent(1.00).cgColor
                dealCardsButton.isEnabled = true
            } else {
                // disable the button
                dealCardsButton.layer.backgroundColor = constantValues.dealCardsButtonColor.withAlphaComponent(0.5).cgColor
                dealCardsButton.isEnabled = false
            }
        }
        
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
        
        determineMatchButtonStatus()
        determineDealButtonStatus()
        updateScore()
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
        static let buttonOutlineColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        static let matchButtonColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        static let dealCardsButtonColor = #colorLiteral(red: 0.2605174184, green: 0.2605243921, blue: 0.260520637, alpha: 1)
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

