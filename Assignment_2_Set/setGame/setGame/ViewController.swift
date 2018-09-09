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
            setCardButtons[index].titleLabel?.numberOfLines = 0
        }
        dealCardsButton.layer.cornerRadius = 8.0
        
        
        updateViewFromModel()
        // debug - trigger lazy
        //gameModel.dealMoreCards()

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
        
        // some way to check if the there are enough buttons to store
        // all of the available cards
        
        for value in gameModel.currentCards {

            // check if we need to assign game card to a button, or if
            // such a mapping already exists
            
            if !mapButtonsToCards.values.contains(value) {
                assignGameCardToControllerButton(of: value)
            }
        }
        
        // update the buttons
        for index in setCardButtons.indices {
            setCardButtons[index].backgroundColor =  mapButtonsToCards[index] != nil ?  #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) : #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
            
            if mapButtonsToCards[index] != nil {
                drawShapesOnCard(on: index)
            }
        }
        
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

