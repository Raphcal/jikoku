//
//  QuarterCircleEnemyMotion.swift
//  Yamato
//
//  Created by Raphaël Calabro on 02/08/2017.
//  Copyright © 2017 Raphaël Calabro. All rights reserved.
//

import Foundation
import Melisse
import GLKit

class QuarterCircleEnemyMotion : EnemyMotion {
    
    let direction: Direction
    let center: Point<GLfloat>
    
    var progress: GLfloat = -0.1
    var speed = GLfloat.pi / 4
    
    init(lifePoints: Int, gameScene: GameScene, center: Point<GLfloat>) {
        self.center = center
        self.direction = center.x == 0 ? .right : .left
        super.init(lifePoints: lifePoints, gameScene: gameScene)
    }
    
    override func updateWith(_ timeSinceLastUpdate: TimeInterval, sprite: Sprite) {
        super.updateWith(timeSinceLastUpdate, sprite: sprite)
        
        progress += speed * direction.value * GLfloat(timeSinceLastUpdate)
        sprite.frame.center = center + Point(x: cos(progress), y: sin(progress)) * (View.instance.width - sprite.frame.width)
        
        shoot(from: sprite, since: timeSinceLastUpdate)
        
        if progress > .pi / 2 + 0.1 {
            sprite.destroy()
        }
    }
    
}
