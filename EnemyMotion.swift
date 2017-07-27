//
//  EnemyMotion.swift
//  Yamato
//
//  Created by Raphaël Calabro on 24/07/2017.
//  Copyright © 2017 Raphaël Calabro. All rights reserved.
//

import Foundation
import Melisse
import GLKit

class EnemyMotion : Motion {
    
    var lifePoints: Int
    let gameScene: GameScene
    let spriteFactory: SpriteFactory
    
    init(lifePoints: Int, gameScene: GameScene) {
        self.lifePoints = lifePoints
        self.gameScene = gameScene
        self.spriteFactory = gameScene.spriteFactory
    }
    
    func updateWith(_ timeSinceLastUpdate: TimeInterval, sprite: Sprite) {
        for other in spriteFactory.sprites {
            if let type = other.type as? SpriteType, type == SpriteType.friendlyShot && other.collides(with: sprite) {
                other.destroy()
                // TODO: Gérer le cas où le tir fait parti de la lecture du kanji
                lifePoints -= 1
                if lifePoints <= 0 {
                    sprite.destroy()
                }
            }
        }
    }
    
}

class StationaryEnemyMotion : EnemyMotion {
    
    var state = State.entering
    
    var speed: GLfloat = 0
    var acceleration: GLfloat = 0
    let deceleration: GLfloat = 1000
    var targetY: GLfloat = 32
    
    var shootingStyle: ShootingStyle!
    
    func load(_ sprite: Sprite) {
        var frame = sprite.frame
        frame.bottom = gameScene.camera.frame.top - 1
        frame.left = random(from: 0, to: View.instance.width - sprite.frame.width)
        sprite.frame = frame
        acceleration = random(from: 200, to: 700)
        
        shootingStyle = StraightShootingStyleDefinition(shotAmount: 1, shotAmountVariation: 0, shotSpeed: 500, shootInterval: 0.25, baseAngle: .pi / 2, inversions: [], inversionInterval: 0, spriteDefinition: 1, space: 0).shootingStyle(spriteFactory: spriteFactory)
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
            shootingStyle.shoot(from: sprite, origin: .down, since: timeSinceLastUpdate)
            break
        }
    }
    
    enum State {
        case entering, decelerating, stationary
    }
    
}
