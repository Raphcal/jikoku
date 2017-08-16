//
//  Shape.swift
//  Yamato
//
//  Created by Raphaël Calabro on 28/07/2017.
//  Copyright © 2017 Raphaël Calabro. All rights reserved.
//

import Foundation
import UIKit
import Melisse

class Shape : Equatable, Hashable {
    static let round: Shape = RoundShape()
    static let triangular: Shape = TriangularShape()
    static let diamond: Shape = DiamondShape()
    
    var hashValue: Int {
        return 1
    }
    
    open func addPath(in rectangle: CGRect, to context: CGContext) {
        // Pas de traitement.
    }
    
    static let all = [Shape.round, .triangular, .diamond]
    
    static var random: Shape {
        return Melisse.random(itemFrom: all)
    }
    
    static func ==(lhs: Shape, rhs: Shape) -> Bool {
        return type(of: lhs) == type(of: rhs)
    }
}

fileprivate final class RoundShape : Shape {
    
    override var hashValue: Int {
        return "round".hashValue
    }
    
    override func addPath(in rectangle: CGRect, to context: CGContext) {
        context.addEllipse(in: rectangle)
    }
    
}

fileprivate final class TriangularShape : Shape {
    
    override var hashValue: Int {
        return "triangular".hashValue
    }
    
    override func addPath(in rectangle: CGRect, to context: CGContext) {
        let origin = rectangle.origin
        let center = rectangle.center
        let size = rectangle.size
        
        context.move(to: CGPoint(x: origin.x, y: origin.y + size.height))
        context.addLine(to: CGPoint(x: center.x, y: origin.y))
        context.addLine(to: CGPoint(x: origin.x + size.width, y: origin.y + size.height))
        context.closePath()
    }
    
}

fileprivate final class DiamondShape : Shape {
    
    override var hashValue: Int {
        return "diamond".hashValue
    }
    
    override func addPath(in rectangle: CGRect, to context: CGContext) {
        let origin = rectangle.origin
        let center = rectangle.center
        let size = rectangle.size
        
        context.move(to: CGPoint(x: center.x, y: origin.y))
        context.addLine(to: CGPoint(x: origin.x + size.width, y: center.y))
        context.addLine(to: CGPoint(x: center.x, y: origin.y + size.height))
        context.addLine(to: CGPoint(x: origin.x, y: center.y))
        context.closePath()
    }
    
}
