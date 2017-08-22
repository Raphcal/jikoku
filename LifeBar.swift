//
//  LifeBar.swift
//  Jikoku
//
//  Created by Raphaël Calabro on 21/08/2017.
//  Copyright © 2017 Raphaël Calabro. All rights reserved.
//

import Foundation
import Melisse
import GLKit

class LifeBar {
    
    var frame = Rectangle<GLfloat>() {
        didSet {
            update()
        }
    }
    
    var value = 0 {
        didSet {
            update()
        }
    }
    var maximum = 0 {
        didSet {
            update()
        }
    }
    
    var progress: GLfloat {
        return GLfloat(fence(0, value, maximum)) / max(GLfloat(maximum), 1)
    }
    
    var front: ColoredQuadrilateral
    var background: ColoredQuadrilateral
    
    fileprivate let referencePool: ReferencePool
    
    fileprivate let frontReference: Int
    fileprivate let backgroundReference: Int
    
    init(referencePool: ReferencePool, vertexPointer: SurfaceArray<GLfloat>, colorPointer: SurfaceArray<GLubyte>) {
        self.referencePool = referencePool
        
        self.backgroundReference = referencePool.next()
        self.frontReference = referencePool.nextAfter(backgroundReference)
        
        self.front = ColoredQuadrilateral(vertexSurface: vertexPointer.surface(at: frontReference), colorSurface: colorPointer.surface(at: frontReference))
        self.background = ColoredQuadrilateral(vertexSurface: vertexPointer.surface(at: frontReference), colorSurface: colorPointer.surface(at: frontReference))
        
        self.front.color = .red
        self.background.color = .black
    }
    
    deinit {
        front.color = nil
        front.quadrilateral = nil
        background.color = nil
        background.quadrilateral = nil

        referencePool.release(frontReference)
        referencePool.release(backgroundReference)
    }
    
    fileprivate func update() {
        background.quadrilateral = Quadrilateral(rectangle: frame)
        front.quadrilateral = Quadrilateral(rectangle: Rectangle(left: frame.left, top: frame.top, width: frame.width * progress, height: frame.height))
    }
    
}
