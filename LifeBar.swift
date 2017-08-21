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
    
    var value = 0 {
        didSet {
            progress = value / max(maximum, 1)
        }
    }
    var maximum = 0 {
        didSet {
            progress = value / max(maximum, 1)
        }
    }
    
    var progress = 0 {
        didSet {
            // TODO: Redimensionner la barre
            
        }
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
    }
    
    deinit {
        front.color = nil
        front.quadrilateral = nil
        background.color = nil
        background.quadrilateral = nil

        referencePool.release(frontReference)
        referencePool.release(backgroundReference)
    }
    
}
