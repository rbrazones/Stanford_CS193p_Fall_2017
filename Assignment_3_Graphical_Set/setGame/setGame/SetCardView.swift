//
//  SetCardView.swift
//  setGame
//
//  Created by Ryan Brazones on 9/13/18.
//  Copyright © 2018 greenred. All rights reserved.
//

import UIKit

@IBDesignable
class SetCardView: UIView {
    
    enum withShape: String {
        case oval = "oval"
        case diamond = "diamond"
        case squiggle = "squiggle"
        static let allValues = [withShape.oval, .diamond, .squiggle]
    }
    
    enum withShade: String {
        case solid = "solid"
        case striped = "striped"
        case unfilled = "unfilled"
        static let allValues = [withShade.solid, .striped, .unfilled]
    }
    
    @IBInspectable
    var color: UIColor = UIColor.red { didSet { setNeedsDisplay() } }
    
    @IBInspectable
    var number: Int = 1 { didSet { setNeedsDisplay() } }
    
    @IBInspectable
    var isSelected: Bool = false { didSet {setNeedsDisplay()}}
    
    var shape: withShape = .diamond
    var shade: withShade = .unfilled
    
    override func draw(_ rect: CGRect) {
        
        drawCardBackground()
        print("draw()")
        
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        drawDiamond(at: center)
        drawTestRect(at: center)
        
        let upperPoint = center.offsetBy(dx: 0, dy: -shapeHeight - (shapeHeight / 4.0))
        drawOval(at: upperPoint)
        drawTestRect(at: upperPoint)
        
        let lowerPoint = center.offsetBy(dx: 0, dy: shapeHeight + (shapeHeight / 4.0))
        drawSquiggle(at: lowerPoint)
        drawTestRect(at: lowerPoint)
    }

}

extension SetCardView {
    
    private func drawTestRect(at point: CGPoint) {
        let test = UIBezierPath()
        
        let distanceToCenter = (shapeWidth / 2 - shapeHeight / 2)
        
        test.move(to: point.offsetBy(dx: -shapeWidth / 2, dy: shapeHeight / 2))
        test.addLine(to: test.currentPoint.offsetBy(dx: 0, dy: -shapeHeight))
        test.addLine(to: test.currentPoint.offsetBy(dx: shapeWidth, dy: 0))
        test.addLine(to: test.currentPoint.offsetBy(dx: 0, dy: shapeHeight))
        test.addLine(to: test.currentPoint.offsetBy(dx: -shapeWidth, dy: 0))
        
        test.move(to: point.offsetBy(dx: -shapeWidth / 2, dy: 0))
        test.addLine(to: test.currentPoint.offsetBy(dx: shapeWidth, dy: 0))
        
        test.move(to: point.offsetBy(dx: -distanceToCenter, dy: shapeHeight / 2))
        test.addLine(to: test.currentPoint.offsetBy(dx: 0, dy: -shapeHeight))
        
        test.move(to: point.offsetBy(dx: distanceToCenter, dy: shapeHeight / 2))
        test.addLine(to: test.currentPoint.offsetBy(dx: 0, dy: -shapeHeight))
        
        UIColor.black.setStroke()
        test.stroke()
    }
    
    private func drawCardBackground() {
        let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: 16.0)
        roundedRect.addClip()
        UIColor.white.setFill()
        UIColor.red.setStroke()
        roundedRect.lineWidth = 7.5
        roundedRect.fill()
        roundedRect.stroke()
        
        print("Draw the background")
    }
    
    private func drawDiamond(at point: CGPoint) {
        let diamondPath = UIBezierPath()
        diamondPath.move(to: point.offsetBy(dx: -shapeWidth / 2, dy: 0))
        diamondPath.addLine(to: point.offsetBy(dx: 0, dy: -shapeHeight / 2))
        diamondPath.addLine(to: point.offsetBy(dx: shapeWidth / 2, dy: 0))
        diamondPath.addLine(to: point.offsetBy(dx: 0, dy: shapeHeight / 2))
        diamondPath.addLine(to: point.offsetBy(dx: -shapeWidth / 2, dy: 0))
        UIColor.green.setStroke()
        UIColor.green.setFill()
        diamondPath.stroke()
        diamondPath.fill()
    }
    
    private func drawOval(at point: CGPoint) {
        let ovalPath = UIBezierPath()
        let distanceToCenter = (shapeWidth / 2 - shapeHeight / 2)
        let leftCenter = point.offsetBy(dx: -distanceToCenter, dy: 0)
        let rightCenter = point.offsetBy(dx: distanceToCenter, dy: 0)
        ovalPath.addArc(withCenter: leftCenter, radius: shapeHeight / 2, startAngle: CGFloat.pi / 2, endAngle: 3 * CGFloat.pi / 2, clockwise: true)
        ovalPath.addLine(to: point.offsetBy(dx: distanceToCenter, dy: -shapeHeight / 2))
        ovalPath.addArc(withCenter: rightCenter, radius: shapeHeight / 2, startAngle: 3 * CGFloat.pi / 2, endAngle: CGFloat.pi / 2, clockwise: true)
        ovalPath.addLine(to: point.offsetBy(dx: -distanceToCenter, dy: shapeHeight / 2))
        UIColor.red.setFill()
        UIColor.red.setStroke()
        ovalPath.stroke()
        ovalPath.fill()
    }
    
    private func drawSquiggle(at point: CGPoint) {
        let squigglePath  = UIBezierPath()
        let distanceToCenter = (shapeWidth / 2 - shapeHeight / 2)
        let upperLeftCenter = point.offsetBy(dx: -distanceToCenter, dy: 0)
        let lowerRightCenter = point.offsetBy(dx: distanceToCenter, dy: 0)
        let testX = shapeWidth / 8
        let testY = shapeHeight / 4
        
        // upper left
        squigglePath.move(to: point.offsetBy(dx: -shapeWidth / 2, dy: 0))
        squigglePath.addArc(withCenter: upperLeftCenter, radius: shapeHeight / 2, startAngle: CGFloat.pi, endAngle: 3 * CGFloat.pi / 2, clockwise: true)
        
        // top middle
        var cp1 = point.offsetBy(dx: 0, dy: -shapeHeight / 2)
        var cp2 = point.offsetBy(dx: 0, dy: testY)
        var endPoint = point.offsetBy(dx: 2 * testX, dy: -testY)
        squigglePath.addCurve(to: endPoint, controlPoint1: cp1, controlPoint2: cp2)
        
        cp1 = point.offsetBy(dx: 2.5 * testX, dy: -1.5 * testY)
        cp2 = point.offsetBy(dx: 2.5 * testX, dy: -2 * testY)
        endPoint = point.offsetBy(dx: 3 * testX, dy: -2 * testY)
        squigglePath.addCurve(to: endPoint, controlPoint1: cp1, controlPoint2: cp2)
        
        // upper right
        cp1 = point.offsetBy(dx: testX * 3.5, dy: -testY * 2)
        cp2 = point.offsetBy(dx: testX * 4, dy: -testY)
        endPoint = point.offsetBy(dx: shapeWidth / 2, dy: 0)
        squigglePath.addCurve(to: endPoint, controlPoint1: cp1, controlPoint2: cp2)
        
        // lower right (symmetric to upper left)
        squigglePath.addArc(withCenter: lowerRightCenter, radius: shapeHeight / 2, startAngle: 0, endAngle: CGFloat.pi / 2, clockwise: true)
        
        // lower middle
        cp1 = point.offsetBy(dx: 0, dy: shapeHeight / 2)
        cp2 = point.offsetBy(dx: 0, dy: -testY)
        endPoint = point.offsetBy(dx: -2 * testX, dy: testY)
        squigglePath.addCurve(to: endPoint, controlPoint1: cp1, controlPoint2: cp2)
        
        cp1 = point.offsetBy(dx: -2.5 * testX, dy: 1.5 * testY)
        cp2 = point.offsetBy(dx: -2.5 * testX, dy: 2 * testY)
        endPoint = point.offsetBy(dx: -3 * testX, dy: 2 * testY)
        squigglePath.addCurve(to: endPoint, controlPoint1: cp1, controlPoint2: cp2)
        
        // lower left (symmertric to upper right)
        cp1 = point.offsetBy(dx: -3.5 * testX, dy: 2 * testY)
        cp2 = point.offsetBy(dx: -4 * testX, dy: testY)
        endPoint = point.offsetBy(dx: -shapeWidth / 2, dy: 0)
        squigglePath.addCurve(to: endPoint, controlPoint1: cp1, controlPoint2: cp2)
        
        UIColor.purple.setStroke()
        UIColor.purple.setFill()
        squigglePath.stroke()
        squigglePath.fill()
        
    }
    
    private struct constantValues {
        
    }
    
    private var shapeHeight: CGFloat {
        //return bounds.size.height / 4.0
        return bounds.size.height / 4.5
    }
    
    private var shapeWidth: CGFloat {
        //return bounds.size.width - (shapeHeight / 4.0)
        return bounds.size.width / 1.5
    }
}

extension CGPoint {
    func offsetBy(dx: CGFloat, dy: CGFloat) -> CGPoint {
        return CGPoint(x: x+dx, y: y+dy)
    }
}
