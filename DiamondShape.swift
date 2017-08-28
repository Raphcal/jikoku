//
//  DiamondShape.swift
//  Jikoku
//
//  Created by Raphaël Calabro on 28/08/2017.
//  Copyright © 2017 Raphaël Calabro. All rights reserved.
//

import Foundation
import QuartzCore

final class DiamondShape : Shape {
    
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
