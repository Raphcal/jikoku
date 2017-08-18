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

fileprivate let maximumSpeed: GLfloat = 800

class StationaryEnemyMotion : EnemyMotion {
    
    var state = State.entering
    
    var speed: GLfloat = 0
    var acceleration: GLfloat = 400
    let deceleration: GLfloat = 1000
    var targetY: GLfloat = 32
    
    var stationaryInterval: TimeInterval = 10
    
    override func load(_ sprite: Sprite) {
        targetY = -sprite.frame.y
        if sprite.frame.width >= View.instance.width / 2 {
            stationaryInterval *= 2
        }
    }
    
    override func updateWith(_ timeSinceLastUpdate: TimeInterval, sprite: Sprite) {
        super.updateWith(timeSinceLastUpdate, sprite: sprite)
        let delta = GLfloat(timeSinceLastUpdate)
        
        switch state {
        case .entering:
            speed = min(speed + acceleration * delta, maximumSpeed)
            var frame = sprite.frame
            frame.y += speed * delta
            if frame.y >= targetY {
                frame.y = targetY
                state = .decelerating
            }
            sprite.frame = frame
        case .decelerating:
            speed -= deceleration * delta
            var frame = sprite.frame
            frame.y += speed * delta
            sprite.frame = frame
            if speed < 0 {
                state = .stationary
                speed = 0
            }
        case .stationary:
            shoot(from: sprite, since: timeSinceLastUpdate)
            stationaryInterval -= timeSinceLastUpdate
            if stationaryInterval < 0 {
                state = .exiting
            }
        case .exiting:
            speed = min(speed + acceleration * delta, maximumSpeed)
            var frame = sprite.frame
            frame.y -= speed * delta
            if frame.bottom < 0 {
                sprite.destroy()
            }
            sprite.frame = frame
        }
    }
    
    enum State {
        case entering, decelerating, stationary, exiting
    }
    
}
