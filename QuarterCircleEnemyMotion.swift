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
    var center: Point<GLfloat>
    
    let initialAngle: GLfloat
    var progress: GLfloat = 0
    var speed = GLfloat.pi / 4
    
    init(lifePoints: Int, gameScene: GameScene, direction: Direction) {
        self.direction = direction
        if direction == .left {
            self.center = Point(x: 0, y: 0)
            self.initialAngle = -0.1
        } else {
            self.center = Point(x: View.instance.width, y: 0)
            self.initialAngle = GLfloat.pi + 0.1
        }
        super.init(lifePoints: lifePoints, gameScene: gameScene)
    }
    
    override func load(_ sprite: Sprite) {
        self.center.y = sprite.frame.y
    }
    
    override func updateWith(_ timeSinceLastUpdate: TimeInterval, sprite: Sprite) {
        super.updateWith(timeSinceLastUpdate, sprite: sprite)
        
        progress += speed * GLfloat(timeSinceLastUpdate)
        let angle = initialAngle + progress * direction.value * -1
        sprite.frame.center = center + Point(x: cos(angle), y: sin(angle)) * (View.instance.width - sprite.frame.width)
        
        shoot(from: sprite, since: timeSinceLastUpdate)
        
        if progress > .pi / 2 + 0.1 {
            sprite.destroy()
        }
    }
    
}
