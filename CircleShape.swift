//
//  CircleShape.swift
//  Jikoku
//
//  Created by Raphaël Calabro on 28/08/2017.
//  Copyright © 2017 Raphaël Calabro. All rights reserved.
//

import Foundation
import QuartzCore

final class CircleShape : Shape {
    
    override var hashValue: Int {
        return "circle".hashValue
    }
    
    override func addPath(in rectangle: CGRect, to context: CGContext) {
        context.addEllipse(in: rectangle)
        context.replacePathWithStrokedPath()
    }
    
}
