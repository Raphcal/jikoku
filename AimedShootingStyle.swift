//
//  AimedShootingStyle.swift
//  Jikoku
//
//  Created by Raphaël Calabro on 18/08/2017.
//  Copyright © 2017 Raphaël Calabro. All rights reserved.
//

import Foundation
import Melisse
import GLKit

struct AimedShootingStyleDefinition : ShootingStyleDefinition {
    
    let origin = ShotOrigin.front
    
    var shotAmount: Int
    var shotAmountVariation: Int
    
    var shotSpeed: GLfloat
    var shootInterval: TimeInterval
    
    var inversions: ShootingStyleInversion
    var inversionInterval: Int
    
    var spriteDefinition: Int
    
    var targetType: SpriteType
    
    func shootingStyle(spriteFactory: SpriteFactory) -> ShootingStyle {
        return AimedShootingStyle(definition: self, spriteFactory: spriteFactory)
    }
    
}

class AimedShootingStyle : ShootingStyle {
    
    var aimedDefinition: AimedShootingStyleDefinition {
        return definition as! AimedShootingStyleDefinition
    }
    
    override func shots(from point: Point<GLfloat>, angle: GLfloat, type: SpriteType) -> [Sprite] {
        var shots = [Sprite]()
        
        var spriteDefinition = spriteFactory.definitions[definition.spriteDefinition]
        spriteDefinition.type = type
        
        for _ in 0 ..< shotAmount {
            let angleToPlayer: GLfloat
            if let players = spriteFactory.groups[aimedDefinition.targetType.group], !players.isEmpty {
                let player = random(itemFrom: players)
                angleToPlayer = player.frame.center.angleTo(point)
            } else {
                angleToPlayer = angle
            }
            
            let speed = Point<GLfloat>(x: cosf(angleToPlayer) * definition.shotSpeed,
                                       y: sinf(angleToPlayer) * definition.shotSpeed)
            let shot = spriteFactory.sprite(spriteDefinition)
            shot.frame.center = point
            shot.motion = ShotMotion(angle: angleToPlayer - .pi / 2, speed: speed)
            shot.hitbox = CenteredSpriteHitbox(sprite: shot, size: Size(width: shot.frame.width * 0.6666, height: shot.frame.height * 0.6666))
            
            shots.append(shot)
        }
        
        return shots
    }
    
}
