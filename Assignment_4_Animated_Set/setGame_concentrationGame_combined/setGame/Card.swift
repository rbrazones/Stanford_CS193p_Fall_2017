//
//  Card.swift
//  concentrationGame
//
//  Created by Ryan Brazones on 8/14/18.
//  Copyright © 2018 greenred. All rights reserved.
//

import Foundation

/*
 *  Structs and classes are almost exactly the same. But, there are 2 major
 *  1) There is no inheritance in structs
 *  2) (MOST IMPORTANT) Structs are value types, and classes are value types
 *      - value types get copied (arrays, ints, strings, are all struct examples)
 *          - swift does copy on write semantics
 *      - reference types: lives in the heap, has pointers to it
 *          - when you pass it around, you just pass pointers to it
 *
 *  Structs also get a free initializer, it initalizes all of their vars (but you have
 *  to actually go through and set them all)
 */

struct Card: Hashable {
    var isFaceUp = false
    var isMatched = false
    var isPreviouslyViewed = false
    private var identifier: Int
    
    var hashValue: Int { return identifier }
    
    static func ==(lhs: Card, rhs: Card) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    // static vars are tied to the type, not a card instance
    private static var identifierFactory = 0
    
    /*
     *  What is a static function? - a card does not understand this message. You send this
     *  to the type itself.
     *
     *  Think of a global or utility function that is tied to the type
     */
    
    private static func getUniqueIdentifier() -> Int {
        // from within a static function, you can access static members
        // dont need Card.identifierFactory, just identifierFactory
        identifierFactory += 1
        return identifierFactory
    }
    
    /*
     *  inits tend to have the same internal/external name in parameters
     */
    
    init(){
        self.identifier = Card.getUniqueIdentifier()
    }
}
