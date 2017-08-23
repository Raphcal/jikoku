//
//  SVG.swift
//  Jikoku
//
//  Created by Raphaël Calabro on 22/08/2017.
//  Copyright © 2017 Raphaël Calabro. All rights reserved.
//

import Foundation
import QuartzCore

struct SVG {
    var shapes: [SVGShape]
    
    init(fileAtPath: String) {
        self.shapes = []
    }
}

protocol SVGShape {
    func draw(in context: CGContext)
}
