//
//  ViewController.swift
//  setGame
//
//  Created by Ryan Brazones on 9/3/18.
//  Copyright © 2018 greenred. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var setCardButtons: [UIButton]!
    @IBOutlet weak var dealCardsButton: UIButton!
    
    private var currentlySelectedCards = [Int]()
    private lazy var gameModel = setGameModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // set all cards to have rounded corners
        for index in setCardButtons.indices {
            setCardButtons[index].layer.cornerRadius = 8.0
            setCardButtons[index].layer.borderWidth = 5.0
            setCardButtons[index].layer.borderColor = UIColor.white.cgColor
            setCardButtons[index].titleLabel?.numberOfLines = 0
        }
        dealCardsButton.layer.cornerRadius = 8.0
        dealCardsButton.layer.backgroundColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1).withAlphaComponent(1.00).cgColor
        dealCardsButton.layer.borderWidth = 0.3
        dealCardsButton.layer.borderColor = UIColor.black.cgColor
        updateViewFromModel()
        // debug - trigger lazy
        //gameModel.dealMoreCards()

    }
    
    @IBAction func touchCardButton(_ sender: UIButton) {
        
        assert(gameModel.selectedCards.count <= 3, "ViewController.touchCardButton: We can only select 3 cards at max")
        
        let buttonIndex = setCardButtons.index(of: sender)!
        if mapButtonsToCards[buttonIndex] != nil {
            
            let cardIndex = mapButtonsToCards[buttonIndex]!
            if gameModel.selectedCards.count == 3 && !gameModel.selectedCards.contains(cardIndex) {
                return // do nothing
            } else {
                gameModel.attemptToSelect(on: cardIndex)
            }
        }
        
        updateViewFromModel()
    }
    
    @IBAction func touchDealMoreCardsButton(_ sender: UIButton) {
        
        // invalidate button to card mappings if we have a match
        if gameModel.selectedCards.count == 3 && gameModel.checkIfCardsMatched() {
            for index in gameModel.selectedCards.indices {
                let removeKeys = mapButtonsToCards.keysForValues(value: gameModel.selectedCards[index])
                for key in removeKeys {
                    mapButtonsToCards.removeValue(forKey: key)
                }
            }
        }
        
        gameModel.dealMoreCards()
        updateViewFromModel()
    }
    private var mapButtonsToCards = Dictionary<Int, Int>()
    
    private func updateViewFromModel(){
    
        assert(gameModel.currentCards.count <= 24, "ViewController.updateViewFromModel: We can only have up to 24 active cards")
        
        func assignGameCardToControllerButton(of card: Int) {
            for index in setCardButtons.indices {
                if mapButtonsToCards[index] == nil {
                    mapButtonsToCards[index] = card
                    return
                }
            }
            
            // TODO: check this can't happen
            print("WE SHOULD NEVER REACH HERE!!!")
        }
        
        func drawShapesOnCard(on card: Int) {
            var cardText = ""
            
            let gameCardIndex = mapButtonsToCards[card]!
            let gameCard = gameModel.gameCards[gameCardIndex]
            let number = constantValues.cardNumbers[gameCard.number]!
            let shape = constantValues.cardShapes[gameCard.shape]!
            let color = constantValues.cardColors[gameCard.color]!
            let shade = constantValues.cardShades[gameCard.shade]!
            var strokeWidth = 7.5
            var foregroundColor = color
            
            // form the text containing the appropriate amount of shapes
            switch number {
            case 1:
                cardText = "\(shape)"
            case 2:
                cardText = "\(shape)\n\(shape)"
            case 3:
                cardText = "\(shape)\n\(shape)\n\(shape)"
            default:
                break
            }
            
            // determine appropriate attributes based on the card shade
            switch shade {
            case "filled":
                strokeWidth = -strokeWidth
                foregroundColor = foregroundColor.withAlphaComponent(1.00)
            case "open":
                foregroundColor = UIColor.white.withAlphaComponent(1.00)
            case "striped":
                strokeWidth = -strokeWidth
                foregroundColor = foregroundColor.withAlphaComponent(0.15)
            default:
                break
            }
            
            // specifying the font
            let font = UIFont.systemFont(ofSize: 35)
            
            let attributes: [NSAttributedStringKey:Any] = [
                .strokeWidth: strokeWidth,
                .foregroundColor: foregroundColor,
                .strokeColor: color,
                .font: font
            ]
            
            let attributedString = NSAttributedString(string: cardText, attributes: attributes)
            setCardButtons[card].setAttributedTitle(attributedString, for: UIControlState.normal)
        }
        
        func enableDealButton() {
            dealCardsButton.isEnabled = true
            dealCardsButton.layer.backgroundColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1).withAlphaComponent(1.00).cgColor
        }
        
        func disabledDealButton() {
            dealCardsButton.isEnabled = false
            dealCardsButton.layer.backgroundColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1).withAlphaComponent(0.5).cgColor
        }
        
        // check if the deal 3 more cards button should even be enabled
        if gameModel.currentCards.count <= 21 {
            enableDealButton()
        } else {
            if gameModel.selectedCards.count == 3 {
                if gameModel.checkIfCardsMatched() {
                    enableDealButton()
                } else {
                    disabledDealButton()
                }
            } else {
                disabledDealButton()
            }
        }
        
        // some way to check if the there are enough buttons to store
        // all of the available cards
        
        for value in gameModel.currentCards {

            // TODO: add a check to remove mappings once cards have been matched
            
            // check if we need to assign game card to a button, or if
            // such a mapping already exists
            
            if !mapButtonsToCards.values.contains(value) {
                assignGameCardToControllerButton(of: value)
            }
        }
        
        // update the buttons
        // - cards display the correct contents
        // - selected cards will be indicated
        for index in setCardButtons.indices {
            // check if the button currently maps to a card
            if mapButtonsToCards[index] != nil {
                let cardIndex = mapButtonsToCards[index]!
                setCardButtons[index].backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                drawShapesOnCard(on: index)
                
                // now check if that card is currently selected
                if gameModel.selectedCards.contains(cardIndex) {
                    setCardButtons[index].layer.borderColor = UIColor.orange.cgColor
                } else {
                    setCardButtons[index].layer.borderColor = UIColor.white.cgColor
                }
            } else {
                setCardButtons[index].backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
                setCardButtons[index].layer.borderColor = UIColor.clear.cgColor
            }
        }
        
        // determine if the "deal more cards" button needs to be enabled or disabled
        
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

