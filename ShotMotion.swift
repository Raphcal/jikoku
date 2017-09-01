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
    let damage: Int
    let camera: Camera
    
    init(angle: GLfloat, speed: Point<GLfloat>, damage: Int) {
        self.angle = angle + .pi / 2
        self.speed = speed
        self.damage = damage
        self.camera = GameScene.current!.camera
    }
    
    func updateWith(_ timeSinceLastUpdate: TimeInterval, sprite: Sprite) {
        sprite.frame.center += speed * GLfloat(timeSinceLastUpdate)
        
        sprite.vertexSurface.setQuadWith(sprite.frame.rotate(angle, withPivot: sprite.frame.center))
        
        camera.removeSpriteIfOutOfView(sprite)
    }
    
}
