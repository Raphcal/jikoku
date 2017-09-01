//
//  DriftingMotion.swift
//  Yamato
//
//  Created by Raphaël Calabro on 10/08/2017.
//  Copyright © 2017 Raphaël Calabro. All rights reserved.
//

import Foundation
import Melisse
import GLKit

class DriftingMotion : Motion {
    
    var speed: Point<GLfloat>
    var alpha: GLfloat = 1
    var color: Color<GLubyte>
    
    init(speed: Point<GLfloat>) {
        self.speed = speed
        self.color = .white
    }
    
    func updateWith(_ timeSinceLastUpdate: TimeInterval, sprite: Sprite) {
        alpha = max(alpha - GLfloat(timeSinceLastUpdate), 0)
        sprite.tint = color * alpha
        sprite.frame.center += speed * GLfloat(timeSinceLastUpdate)
        
        if alpha < 0.5 {
            speed = speed * 0.9
        }
        if alpha == 0 {
            sprite.destroy()
        }
    }
    
}

func *(lhs: Color<GLubyte>, rhs: GLfloat) -> Color<GLubyte> {
    return Color(red: GLubyte(GLfloat(lhs.red) * rhs), green: GLubyte(GLfloat(lhs.green) * rhs), blue: GLubyte(GLfloat(lhs.blue) * rhs), alpha: GLubyte(GLfloat(lhs.alpha) * rhs))
}
