//
//  SetCardGridView.swift
//  setGame
//
//  Created by Ryan Brazones on 9/16/18.
//  Copyright © 2018 greenred. All rights reserved.
//

import UIKit

class SetCardGridView: UIView, UIGestureRecognizerDelegate {

    var currentCards = [SetCardView]() { didSet{ setNeedsLayout(); setNeedsDisplay() }}
    var discardPile = SetCardView()
    var drawCardPile = SetCardView()
    var delegate: TouchSetCardDelegate?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutCards()
        print("current number of cards = \(currentCards.count)")
    }
    
    // send the cardIndex to parent ViewController to be dealt with
    @objc func handleTapOnCard(_ sender: AnyObject){
        if let test = sender.view?.tag { delegate?.touchedSetCard(with: test) }
    }
}

extension SetCardGridView {
    
    func removeCard(card: SetCardView) {
        let removeIndex = currentCards.index(of: card)!
        card.removeFromSuperview()
        currentCards.remove(at: removeIndex)
        
        // fade out temporary animator
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.5,
                                                       delay: 0,
                                                       options: [],
                                                       animations: { card.alpha = 0 },
                                                       completion: nil)
        
        setNeedsLayout()
    }
    
    func shuffleCards() {
        let numberOfCards = currentCards.count
        for index in currentCards.indices {
            var swapIndex = Int(arc4random_uniform(UInt32(numberOfCards - index)))
            swapIndex += index
            currentCards.swapAt(index, swapIndex)
        }
        setNeedsLayout()
    }
    
    private func layoutCards() {
        
        if currentCards.count == 0 { return }
        
        let (rows, columns) = determineOptimalRowsColumnsWithExtraRowAdded()
        let (cardWidth, cardHeight) = determineCardDimensions(rows: rows, columns: columns)
        let (horinzontalSpacing, verticalSpacing) = determineBestSpacingBetweenCards(for: cardWidth, and: cardHeight, rows: rows, cols: columns)
        
        // layout points to place cards in advance based on how many
        // cards we have to layout, and the determined spacing between
        // those cards
        
        var points = [CGPoint]()
        for j in 0..<(rows - 1) {
            for i in 0..<columns {
                points += [CGPoint(x: CGFloat(i) * (cardWidth + horinzontalSpacing),
                                   y: CGFloat(j) * (cardHeight + verticalSpacing))]
            }
        }
        
        // determine the points where the discard pile and draw new
        // card pile need to be placed
        // [Draw] - [Discard]
        
        let centerCardsOffset = (bounds.size.width - (2 * cardWidth + horinzontalSpacing)) / 2
        
        let discardPilePoint = CGPoint(x: centerCardsOffset,
                                       y: CGFloat(rows - 1) * (cardHeight + verticalSpacing))
        
        let drawNewCardPoint = CGPoint(x: centerCardsOffset + cardWidth + horinzontalSpacing,
                                       y: CGFloat(rows - 1) * (cardHeight + verticalSpacing))
        
        // place the discard and draw new card piles first
        discardPile.isFaceUp = false
        drawCardPile.isFaceUp = false
        
        print("bounds is \(bounds.size)")
        print("point is \(discardPilePoint)")
        print("point is \(drawNewCardPoint)")
        
        if (!subviews.contains(discardPile)) {
            discardPile.frame.size = CGSize(width: cardWidth, height: cardHeight)
            discardPile.isHidden = false
            discardPile.isOpaque = false
            discardPile.frame.origin = discardPilePoint
            addSubview(discardPile)
        } else {
            animateCardObject(on: discardPile, to: discardPilePoint, with: cardWidth, and: cardHeight)
        }
        
        if (!subviews.contains(drawCardPile)) {
            drawCardPile.frame.size = CGSize(width: cardWidth, height: cardHeight)
            drawCardPile.isHidden = false
            drawCardPile.isOpaque = false
            drawCardPile.frame.origin = drawNewCardPoint
            addSubview(drawCardPile)
        } else {
            animateCardObject(on: drawCardPile, to: drawNewCardPoint, with: cardWidth, and: cardHeight)
        }
        
        // layout the cards on the pre-determined points
        var temp = 0
        for card in currentCards {
            card.frame.size = CGSize(width: cardWidth, height: cardHeight)
            
            if subviews.contains(card){
                //print("Old Card")
                
                // we attempt to re-arrange the cards
                animateCardObject(on: card, to: points[temp], with: cardWidth, and: cardHeight)
                //animateCardObject(on: card, to: discardPilePoint)
                
            } else {
                //print("new card")
                addSubview(card)
                let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapOnCard))
                gestureRecognizer.delegate = self
                card.addGestureRecognizer(gestureRecognizer)
            }
        
            //card.frame.origin = points[temp]
            card.tag = currentCards.index(of: card)!
            card.isOpaque = false
            temp += 1
        }
    }
    
    private func animateCardObject(on card: SetCardView, to point: CGPoint, with width: CGFloat, and height: CGFloat) {
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.5,
                                                       delay: 0,
                                                       options: [],
                                                       animations: {
                                                           card.frame.origin = point
                                                           card.frame.size = CGSize(width: width, height: height)
                                                       },
                                                       completion: nil)
    }
    
    private func determineBestSpacingBetweenCards(for width: CGFloat, and height: CGFloat, rows: Int, cols: Int) -> (CGFloat, CGFloat) {
        var horizontalSpacing = constants.minDistanceBetweenCards
        var verticalSpacing = constants.minDistanceBetweenCards
        let numberOfHorizontalSpaces = CGFloat(cols - 1)
        let numberOfHorizontalCards = CGFloat(cols)
        let numberOfVerticalSpaces = CGFloat(rows - 1)
        let numberOfVerticalCards = CGFloat(rows)
        
        // check horizontal spacing first
        if (width * numberOfHorizontalCards + numberOfHorizontalSpaces * horizontalSpacing < bounds.size.width){
            let remainingHorizontalSpace = bounds.size.width - (width * numberOfHorizontalCards)
            horizontalSpacing = remainingHorizontalSpace / numberOfHorizontalSpaces
        }
        // then check vertical scaling
        if (height * numberOfVerticalCards + numberOfVerticalSpaces * verticalSpacing < bounds.size.height){
            let remainingVerticalSpace = bounds.size.height - (height * numberOfVerticalCards)
            verticalSpacing = remainingVerticalSpace / numberOfVerticalSpaces
        }
        
        return (horizontalSpacing, verticalSpacing)
    }
    
    private func determineOptimalRowsColumnsWithExtraRowAdded () -> (Int, Int) {
        let boundsWidthHeightRatio = bounds.size.width / bounds.size.height
        let rowsPerColumn = Double(constants.cardWidthHeightRatio / boundsWidthHeightRatio)
        let numberOfCards = Double(currentCards.count)
        let columnsUnrounded = sqrt(numberOfCards / rowsPerColumn)
        var columns = columnsUnrounded.rounded()
        let rows = (numberOfCards / columnsUnrounded).rounded()
        
        while (columns * rows < Double(currentCards.count)){
            columns += 1
        }
        
        // [rows + 1] in order to always have extra row for deck/discard piles
        return(Int(rows + 1), Int(columns))
    }
    
    private func determineCardDimensions(rows: Int, columns: Int) -> (CGFloat, CGFloat) {
        
        // account for the minimum spacing between cards
        //let effectiveWidth = bounds.size.width - (CGFloat(currentCards.count) - 1) * constants.minDistanceBetweenCards
        //let effectiveHeight = bounds.size.height - (CGFloat(currentCards.count) - 1) * constants.minDistanceBetweenCards
        let effectiveWidth = bounds.size.width - (CGFloat(columns) - 1) * constants.minDistanceBetweenCards
        let effectiveHeight = bounds.size.height - (CGFloat(rows) - 1) * constants.minDistanceBetweenCards
        
        // first try sizing the cards based off of width
        let possibleCardWidth = effectiveWidth / CGFloat(columns)
        let possibleCardHeight = possibleCardWidth / constants.cardWidthHeightRatio
        if (possibleCardHeight * CGFloat(rows) <= effectiveHeight){
            return (possibleCardWidth, possibleCardHeight)
        }
        
        // Otherwise, we base the card size off the height
        let secondPossibleCardHeight = effectiveHeight / CGFloat(rows)
        let secondPossibleCardWidth = secondPossibleCardHeight * constants.cardWidthHeightRatio
        if (possibleCardWidth * CGFloat(columns) <= effectiveWidth){
            return (secondPossibleCardWidth, secondPossibleCardHeight)
        }
        else {
            assert(true, "SetCardGridView.determineCardDimensions: Invalid card size. We should never reach here")
            return(0, 0)
        }
    }
    
    private struct constants {
        static let cardWidthHeightRatio: CGFloat = 5 / 8
        static let minDistanceBetweenCards: CGFloat = 4
    }
}
