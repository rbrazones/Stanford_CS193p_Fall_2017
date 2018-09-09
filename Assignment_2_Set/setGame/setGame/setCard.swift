//
//  setCard.swift
//  setGame
//
//  Created by Ryan Brazones on 9/5/18.
//  Copyright © 2018 greenred. All rights reserved.
//

import Foundation

struct setCard {
    
    enum shapeOptions: String {
        case shapeA
        case shapeB
        case shapeC
        
        static let allValues = [shapeA, shapeB, shapeC]
    }
    
    enum colorOptions: String {
        case colorA
        case colorB
        case colorC
        
        static let allValues = [colorA, colorB, colorC]
    }
    
    enum shadeOptions: String {
        case shadeA
        case shadeB
        case shadeC
        
        static let allValues = [shadeA, shadeB, shadeC]
    }
    
    enum numberOptions: String{
        case numberA
        case numberB
        case numberC
        
        static let allValues = [numberA, numberB, numberC]
    }
    
    var shape: shapeOptions
    var color: colorOptions
    var shade: shadeOptions
    var number: numberOptions
    
    init(shape: shapeOptions, color: colorOptions, shading: shadeOptions, number: numberOptions) {
        self.shape = shape
        self.color = color
        self.shade = shading
        self.number = number
    }
}
