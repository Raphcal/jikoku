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

protocol HasLifePoints {
    var lifePoints: Int { get }
    var lifeBar: LifeBar? { get set }
}

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
    
    init(plane: Plane) {
        self.background = plane.coloredQuadrilateral()
        self.background.color = .black
        
        self.front = plane.coloredQuadrilateral()
        self.front.color = .red
    }
    
    deinit {
        self.front.color = nil
        self.front.quadrilateral = nil
        self.background.color = nil
        self.background.quadrilateral = nil
    }
    
    fileprivate func update() {
        background.quadrilateral = Quadrilateral(rectangle: frame)
        front.quadrilateral = Quadrilateral(rectangle: Rectangle(left: frame.left, top: frame.top, width: frame.width * progress, height: frame.height))
    }
    
}
