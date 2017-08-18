//
//  SpriteBlueprint.swift
//  Yamato
//
//  Created by Raphaël Calabro on 08/08/2017.
//  Copyright © 2017 Raphaël Calabro. All rights reserved.
//

import Foundation
import Melisse
import GLKit

struct SpriteBlueprint : Hashable, Equatable, Packable {
    var paintedShapes: [PaintedShape]
    var size: Size<GLfloat>
    
    var shadow: SpriteBlueprint {
        return SpriteBlueprint(paintedShapes: [PaintedShape(shape: paintedShapes[0].shape, paint: ShadowPaint())], size: size * 1.5)
    }
    
    init(paintedShapes: [PaintedShape], size: Size<GLfloat>) {
        self.paintedShapes = paintedShapes
        self.size = size
    }
    
    var packSize: Size<Int> {
        return Size(width: Int(size.width), height: Int(size.height))
    }
    
    var hashValue: Int {
        return paintedShapes.hashValue &* 37
            &+ size.hashValue &* 181
    }
    
    static func ==(lhs: SpriteBlueprint, rhs: SpriteBlueprint) -> Bool {
        return lhs.paintedShapes == rhs.paintedShapes
            && lhs.size == rhs.size
    }
    
}
