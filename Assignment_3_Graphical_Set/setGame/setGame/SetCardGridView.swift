//
//  SetCardGridView.swift
//  setGame
//
//  Created by Ryan Brazones on 9/16/18.
//  Copyright © 2018 greenred. All rights reserved.
//

import UIKit

class SetCardGridView: UIView {

    var currentCards = [SetCardView]()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        print("amount of cards in grid view = \(currentCards.count)")
        
        //let testCard = currentCards[0]
        //testCard.color = UIColor.purple
        //testCard.shape = .squiggle
        //testCard.number = 3
        //testCard.shade = .striped
        //testCard.isOpaque = false
        //testCard.frame.size = CGSize(width: 50, height: 80)
        
        let (rows, columns) = determineOptimalRowsColumns()
        
        for _ in 0..<rows {
            for _ in 0..<columns {
                
            }
        }
        
        
        print ("rows = \(rows)")
        print ("columns = \(columns)")
        
        //addSubview(testCard)
    }

}

extension SetCardGridView {
    
    private func determineOptimalRowsColumns () -> (Int, Int) {
        let boundsWidthHeightRatio = bounds.size.width / bounds.size.height
        let rowsPerColumn = Double(constants.cardWidthHeightRatio / boundsWidthHeightRatio)
        let numberOfCards = Double(currentCards.count)
        let columns = sqrt(numberOfCards / rowsPerColumn).rounded(.up)
        let rows = (numberOfCards / columns).rounded()
        return(Int(rows), Int(columns))
    }
    
    private struct constants {
        static let cardWidthHeightRatio: CGFloat = 5 / 8
        static let distanceBetweenCards: CGFloat = 0
    }
}
