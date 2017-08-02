//
//  StationaryEnemyMotion.swift
//  Yamato
//
//  Created by Raphaël Calabro on 02/08/2017.
//  Copyright © 2017 Raphaël Calabro. All rights reserved.
//

import Foundation
import Melisse
import GLKit

class StationaryEnemyMotion : EnemyMotion {
    
    var state = State.entering
    
    var speed: GLfloat = 0
    var acceleration: GLfloat = 0
    let deceleration: GLfloat = 1000
    var targetY: GLfloat = 32
    
    override func load(_ sprite: Sprite) {
        var frame = sprite.frame
        frame.bottom = gameScene.camera.frame.top - 1
        frame.left = random(from: 0, to: View.instance.width - sprite.frame.width)
        sprite.frame = frame
        acceleration = random(from: 200, to: 700)
        
        shootingStyles = [StraightShootingStyleDefinition(
            shotAmount: 1,
            shotAmountVariation: 0,
            shotSpeed: 250,
            shootInterval: 0.5,
            inversions: [],
            inversionInterval: 0,
            spriteDefinition: 1,
            space: 0).shootingStyle(spriteFactory: spriteFactory)]
    }
    
    override func updateWith(_ timeSinceLastUpdate: TimeInterval, sprite: Sprite) {
        super.updateWith(timeSinceLastUpdate, sprite: sprite)
        let delta = GLfloat(timeSinceLastUpdate)
        
        switch state {
        case .entering:
            speed += acceleration * delta
            var frame = sprite.frame
            frame.y += speed * delta
            if frame.y >= targetY {
                frame.y = targetY
                state = .decelerating
            }
            sprite.frame = frame
            break
        case .decelerating:
            speed -= deceleration * delta
            var frame = sprite.frame
            frame.y += speed * delta
            sprite.frame = frame
            if speed < 0 {
                state = .stationary
            }
        case .stationary:
            shoot(from: sprite, since: timeSinceLastUpdate)
            break
        }
    }
    
    enum State {
        case entering, decelerating, stationary
    }
    
}
