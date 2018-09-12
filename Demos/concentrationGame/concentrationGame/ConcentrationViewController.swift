//
//  ViewController.swift
//  concentrationGame
//
//  Created by Ryan Brazones on 8/14/18.
//  Copyright © 2018 greenred. All rights reserved.
//

import UIKit

class ConcentrationViewController: UIViewController {

    @IBOutlet private var cardButtons: [UIButton]!
    
    @IBAction private func touchButton(_ sender: UIButton) {
        if let cardNumber = cardButtons.index(of: sender){
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        }
    }
    
    // didSet can also be applied on outlets!
    @IBOutlet weak var flipCountLabel: UILabel! {
        didSet{
            updateFlipCountLabel()
        }
    }
    
    @IBOutlet weak var scoreLabel: UILabel! {
        didSet {
            updateScoreLabel()
        }
    }
    
    
    // reset the game when button is pressed
    @IBAction func newGamePress(_ sender: UIButton) {
        game.resetGame()
        game.shuffleDeck()
        emojiChoices = determineTheme()
        updateViewFromModel()
    }
    
    // remember that lazy cannot have a property observer (didSet)
    // private - the number of cards is intimately tied to the UI
    private lazy var game = ConcentrationModel(numberOfPairsOfCards: numberOfPairsOfCards)

    private lazy var emojiChoices: String = determineTheme()

    func determineTheme() -> String {
        // 6 possible themes
        let possibleThemes = [
            "😍🤓🤬😱🤯🤢👿🤗😷😭🤩🙃", // Faces Theme
            "⚽️🏀🏈⚾️🎱🏉🏐🎾🏓🏑⛳️🏏", // Sports Theme
            "🇧🇴🇧🇿🇧🇩🇦🇹🇦🇷🏁🏴🏳️🏳️‍🌈🇨🇿🇨🇾🇨🇬", // Flags Theme
            "🍕🥪🥙🌮🍟🍔🌭🍖🥞🥓🥩🍗", // Food Theme
            "🦈🐊🐅🐆🦏🐘🦍🦓🐪🐫🦒🐃", // Animals Theme
            "🤲🤝✊🙏✍️💪🖐🤙👌👎👆🤟"  // Hands Theme
        ]
        
        let randomArrayIndex = Int(arc4random_uniform(UInt32(possibleThemes.count)))
        emoji.removeAll()
        return possibleThemes[randomArrayIndex]
    }

    var numberOfPairsOfCards: Int {
        get {
            return (cardButtons.count + 1) / 2
        }
    }
    
    private func updateScoreLabel() {
        let attributes: [NSAttributedStringKey:Any] = [
            .strokeWidth : 5.0,
            .strokeColor : #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)
        ]
        let attributedString = NSAttributedString(string: "Score: \(game.gameScore)", attributes: attributes)
        scoreLabel.attributedText = attributedString
        
    }
    
    private func updateFlipCountLabel() {
        let attributes: [NSAttributedStringKey:Any] = [
            .strokeWidth : 5.0,
            .strokeColor : #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1)
        ]
        let attributedString = NSAttributedString(string: "Flips: \(game.flipCount)", attributes: attributes)
        flipCountLabel.attributedText = attributedString
    }
    
    func updateViewFromModel() {
        // indices is method of array that returns countable range of all
        // indices in the array
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            if card.isFaceUp {
                button.setTitle(emoji(for: card), for: UIControlState.normal)
                button.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            } else {
                button.setTitle("", for: UIControlState.normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 0) : #colorLiteral(red: 1, green: 0.5781051517, blue: 0, alpha: 1)
            }
        }
        updateFlipCountLabel()
        updateScoreLabel()
    }
    
    private var emoji = Dictionary<Card, String>()
    
    private func emoji(for card: Card) -> String {
        
        if emoji[card] == nil, emojiChoices.count > 0 {
            // showcasing how to index into a string
            let randomStringIndex = emojiChoices.index(emojiChoices.startIndex, offsetBy: emojiChoices.count.arc4random)
            emoji[card] = String(emojiChoices.remove(at: randomStringIndex))
        }

        return emoji[card] ?? "?"
    }
}

extension Int {
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
    }
}


