//
//  ConcentrationModel.swift
//  concentrationGame
//
//  Created by Ryan Brazones on 8/14/18.
//  Copyright © 2018 greenred. All rights reserved.
//

/*
 *  Classes get a free init as long as all of their properites are initialized
 */

import Foundation

class ConcentrationModel {
    
    private(set) var cards = [Card]()
    private(set) var flipCount = 0
    private(set) var gameScore = 0
    
    private var indexOfOneAndOnlyFaceUpCard: Int? {
        get {
            return cards.indices.filter {cards[$0].isFaceUp}.oneAndOnly
        }
        set(newValue) {
            for index in cards.indices {
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }
    
    func resetGame() {
        for index in cards.indices {
            cards[index].isFaceUp = false
            cards[index].isMatched = false
            cards[index].isPreviouslyViewed = false
        }
        flipCount = 0
        gameScore = 0
    }
    
    func chooseCard(at index: Int){
        
        assert(cards.indices.contains(index), "Concentration.chooseCard(at: \(index)): chosen index not in cards")
        
        flipCount += 1
        
        if !cards[index].isMatched {
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
                // check if cards match
                // we can compare cards directly now from implementing the protocols for hashable
                if cards[matchIndex] == cards[index] {
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                    gameScore += 2
                } else {
                    if cards[index].isPreviouslyViewed {
                        gameScore -= 1
                    }
                    if cards[matchIndex].isPreviouslyViewed {
                        gameScore -= 1
                    }
                    cards[index].isPreviouslyViewed = true
                    cards[matchIndex].isPreviouslyViewed = true
                }
                cards[index].isFaceUp = true
            } else {
                indexOfOneAndOnlyFaceUpCard = index
            }
        }
    }
    
    // shuffles the deck of cards
    func shuffleDeck() {
        let numberOfCards = cards.count
        for index in cards.indices {
            var swapIndex = Int(arc4random_uniform(UInt32(numberOfCards - index)))
            swapIndex = index + swapIndex
            cards.swapAt(index, swapIndex)
        }
    }
    
    init(numberOfPairsOfCards: Int){
        
        assert(numberOfPairsOfCards > 0, "Concentration.init(\(numberOfPairsOfCards)): invalid")
        
        for _ in 0..<numberOfPairsOfCards {
            let card = Card()
            cards += [card, card]
        }
        
        // shuffle the cards after making the deck
        shuffleDeck()
    }
}

// string and array are collection - we are extending this to simplify
extension Collection {
    var oneAndOnly: Element? {
        return count == 1 ? first : nil
    }
}
