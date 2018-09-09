//
//  setGameModel.swift
//  setGame
//
//  Created by Ryan Brazones on 9/5/18.
//  Copyright © 2018 greenred. All rights reserved.
//

import Foundation

class setGameModel {
    
    var gameCards = [setCard]()
    var currentCards = [Int]()
    var availableCards = [Int]()
    var matchedCards = [Int]()
    var selectedCards = [Int]()
    
    private func createDeckOfCards() {
        // fill deck with cards
        // cycle through all shape/color/shade combinations
        for shape in setCard.shapeOptions.allValues {
            for color in setCard.colorOptions.allValues {
                for shade in setCard.shadeOptions.allValues {
                    for number in setCard.numberOptions.allValues {
                        let card = setCard(shape: shape, color: color, shading: shade, number: number)
                        gameCards += [card]
                    }
                }
            }
        }
        // initially mark all cards as available
        for index in gameCards.indices {
            availableCards += [index]
        }
    }
    
    func checkIfCardsMatched(cards indices: [Int]) -> Bool {
        
        assert(indices.count == 3, "setGameModel.checkIfCardsMatched: invalid number of cards to compare")
        
        let card1 = gameCards[indices[0]]
        let card2 = gameCards[indices[1]]
        let card3 = gameCards[indices[2]]
        
        if (card1.color == card2.color) && (card2.color == card3.color) {
            return true
        }
        
        if (card1.shape == card2.shape) && (card2.shape == card3.shape) {
            return true
        }
        
        if (card1.shade == card2.shade) && (card2.shade == card3.shade) {
            return true
        }
        
        if (card1.number == card2.number) && (card2.number == card3.number) {
            return true
        }
        
        return false
    }
    
    func dealMoreCards() {
        print("dealMoreCards()")
    }
    
    func startNewGame() {
        
        // clear out arrays from past games
        gameCards.removeAll()
        currentCards.removeAll()
        availableCards.removeAll()
        matchedCards.removeAll()
        selectedCards.removeAll()
        
        // restart things
        createDeckOfCards()
        
        // select 12 initial cards to start the game
        for _ in 1...12 {
            let randomIndex = Int(arc4random_uniform(UInt32(availableCards.count)))
            let tempInt = availableCards.remove(at: randomIndex)
            currentCards += [tempInt]
        }
        
        print("Current cards = \(currentCards)")
        print("Available cards = \(availableCards)")
        print("Matched cards = \(matchedCards)")
        print("Selected cards = \(selectedCards)")
    }
    
    init() {
        startNewGame()
    }
}
