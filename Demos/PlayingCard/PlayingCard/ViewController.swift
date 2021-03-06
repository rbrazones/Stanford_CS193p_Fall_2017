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
    
    @IBOutlet var cardViews: [PlayingCardView]!
    
    lazy var animator = UIDynamicAnimator(referenceView: self.view)
    
    lazy var cardBehavior = CardBehavior(in: animator)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var cards = [PlayingCard]()
        for _ in 1...((cardViews.count+1)/2) {
            let card = deck.draw()!
            cards += [card,card]
        }
        
        for cardView in cardViews {
            cardView.isFaceUp = false
            let card = cards.remove(at: cards.count.arc4random)
            cardView.rank = card.rank.order
            cardView.suit = card.suit.rawValue
            cardView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(flipCard(_:))))
            cardBehavior.addItem(cardView)

        }
    }
    
    private var faceCardUpViews: [PlayingCardView] {
        return cardViews.filter {$0.isFaceUp && !$0.isHidden && $0.transform != CGAffineTransform.identity.scaledBy(x: 3.0, y: 3.0) && $0.alpha == 1}
    }
    
    private var faceUpCardViewsMatch: Bool {
        return faceCardUpViews.count == 2 &&
        faceCardUpViews[0].rank == faceCardUpViews[1].rank &&
        faceCardUpViews[0].suit == faceCardUpViews[1].suit
    }
    
    var lastChosenCardView: PlayingCardView?
    
    @objc func flipCard(_ recognizer: UITapGestureRecognizer) {
        switch recognizer.state {
        case .ended:
            if let chosenCardView = recognizer.view as? PlayingCardView, faceCardUpViews.count < 2 {
                lastChosenCardView = chosenCardView
                cardBehavior.removeItem(chosenCardView)
                
                UIView.transition(with: chosenCardView,
                                  duration: 0.6,
                                  options: .transitionFlipFromLeft,
                                  animations: {
                                    chosenCardView.isFaceUp = !chosenCardView.isFaceUp
                },
                                  completion: {finished in
                                    let cardsToAnimate = self.faceCardUpViews
                                    if self.faceUpCardViewsMatch {
                                        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.6, delay: 0, options: [], animations: {
                                            cardsToAnimate.forEach {
                                                $0.transform = CGAffineTransform.identity.scaledBy(x: 3.0, y: 3.0)
                                            }
                                        }, completion: {position in
                                            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.6, delay: 0, options: [], animations: {
                                                cardsToAnimate.forEach {
                                                    $0.transform = CGAffineTransform.identity.scaledBy(x: 0.1, y: 0.1)
                                                    $0.alpha = 0
                                                }
                                            }, completion: {position in
                                                cardsToAnimate.forEach {
                                                    $0.isHidden = true
                                                    $0.alpha = 1
                                                    $0.transform = .identity
                                                }
                                            }
                                            )
                                        }
                                        )
                                    } else if self.faceCardUpViews.count == 2 {
                                        if chosenCardView == self.lastChosenCardView {cardsToAnimate.forEach { cardView in
                                            UIView.transition(with: cardView,
                                                              duration: 0.6,
                                                              options: .transitionFlipFromLeft,
                                                              animations: {
                                                                cardView.isFaceUp = false
                                                                
                                            }, completion: { finished in
                                                self.cardBehavior.addItem(cardView)
                                            }
                                            )
                                            }}
                                        
                                    } else {
                                        if !chosenCardView.isFaceUp {
                                            self.cardBehavior.addItem(chosenCardView)
                                        }
                                    }
                                    
                }
                )
                
            }
        default: break
        }
    }
}

extension CGFloat {
    var arc4random: CGFloat {
        if self > 0 {
            return CGFloat(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -CGFloat(arc4random_uniform(UInt32(self)))
        } else {
            return 0
        }
    }
}
