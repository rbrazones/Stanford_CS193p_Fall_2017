//
//  SetCardGridView.swift
//  setGame
//
//  Created by Ryan Brazones on 9/16/18.
//  Copyright © 2018 greenred. All rights reserved.
//

import UIKit

class SetCardGridView: UIView, UIGestureRecognizerDelegate {

    var currentCards = [SetCardView]() { didSet{ setNeedsLayout() }}
    
    var delegate: TouchSetCardDelegate?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutCards()
    }
    
    // send the cardIndex to parent ViewController to be dealt with
    @objc func handleTapOnCard(_ sender: AnyObject){
        if let test = sender.view?.tag { delegate?.touchedSetCard(with: test) }
    }
}

extension SetCardGridView {
    
    private func layoutCards() {
        let (rows, columns) = determineOptimalRowsColumns()
        let (cardWidth, cardHeight) = determineCardDimensions(rows: rows, columns: columns)
        let (horinzontalSpacing, verticalSpacing) = determineBestSpacingBetweenCards(for: cardWidth, and: cardHeight, rows: rows, cols: columns)
        
        print("card width = \(cardWidth)")
        print("card height = \(cardHeight)")
        
        print("horizontal space = \(horinzontalSpacing)")
        print("vertical space = \(verticalSpacing)")
        
        // layout points to place cards in advance based on how many
        // cards we have to layout, and the determined spacing between
        // those cards
        var points = [CGPoint]()
        for j in 0..<rows {
            for i in 0..<columns {
                points += [CGPoint(x: CGFloat(i) * (cardWidth + horinzontalSpacing),
                                   y: CGFloat(j) * (cardHeight + verticalSpacing))]
            }
        }
        
        // layout the cards on the pre-determined points
        var temp = 0
        for card in currentCards {
            card.frame.size = CGSize(width: cardWidth, height: cardHeight)
            addSubview(card)
            let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapOnCard))
            gestureRecognizer.delegate = self
            card.addGestureRecognizer(gestureRecognizer)
            card.frame.origin = points[temp]
            card.tag = currentCards.index(of: card)!
            card.isOpaque = false
            temp += 1
        }
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
    
    private func determineOptimalRowsColumns () -> (Int, Int) {
        let boundsWidthHeightRatio = bounds.size.width / bounds.size.height
        let rowsPerColumn = Double(constants.cardWidthHeightRatio / boundsWidthHeightRatio)
        let numberOfCards = Double(currentCards.count)
        let columnsUnrounded = sqrt(numberOfCards / rowsPerColumn)
        var columns = columnsUnrounded.rounded()
        let rows = (numberOfCards / columnsUnrounded).rounded()
        
        while (columns * rows < Double(currentCards.count)){
            columns += 1
        }
        
        print("bounds width = \(bounds.size.width)")
        print("bounds height = \(bounds.size.height)")
        print("number of cards = \(numberOfCards)")
        print("columns unrounded = \(columnsUnrounded)")
        print("columns rounded = \(columns)")
        print("rows unrounded = \(numberOfCards / columnsUnrounded)")
        print("rows rounded = \(rows)")
        return(Int(rows), Int(columns))
    }
    
    private func determineCardDimensions(rows: Int, columns: Int) -> (CGFloat, CGFloat) {
        
        // account for the minimum spacing between cards
        //let effectiveWidth = bounds.size.width - (CGFloat(currentCards.count) - 1) * constants.minDistanceBetweenCards
        //let effectiveHeight = bounds.size.height - (CGFloat(currentCards.count) - 1) * constants.minDistanceBetweenCards
        let effectiveWidth = bounds.size.width - (CGFloat(columns) - 1) * constants.minDistanceBetweenCards
        let effectiveHeight = bounds.size.height - (CGFloat(rows) - 1) * constants.minDistanceBetweenCards
        
        print("Effective Width = \(effectiveWidth)")
        print("Effective Height = \(effectiveHeight)")
        
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
        static let minDistanceBetweenCards: CGFloat = 2
    }
}
