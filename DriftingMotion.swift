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
    
    init(speed: Point<GLfloat>) {
        self.speed = speed
    }
    
    func updateWith(_ timeSinceLastUpdate: TimeInterval, sprite: Sprite) {
        alpha = max(alpha - GLfloat(timeSinceLastUpdate), 0)
        sprite.alpha = GLubyte(alpha * 255)
        sprite.frame.center += speed * GLfloat(timeSinceLastUpdate)
        
        if alpha < 0.5 {
            speed = speed * 0.9
        }
        if alpha == 0 {
            sprite.destroy()
        }
    }
    
}
