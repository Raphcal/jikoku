//
//  ShotMotion.swift
//  Yamato
//
//  Created by Raphaël Calabro on 20/07/2017.
//  Copyright © 2017 Raphaël Calabro. All rights reserved.
//

import Melisse
import GLKit

struct ShotMotion : Motion {
    
    let angle: GLfloat
    let speed: Point<GLfloat>
    
    func updateWith(_ timeSinceLastUpdate: TimeInterval, sprite: Sprite) {
        sprite.frame.center += speed * GLfloat(timeSinceLastUpdate)
        
        sprite.vertexSurface.setQuadWith(sprite.frame.rotate(angle, withPivot: sprite.frame.center))
        
        GameScene.current!.camera.removeSpriteIfOutOfView(sprite)
    }
    
}
