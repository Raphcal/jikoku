//
//  StraightShootingStyle.swift
//  Yamato
//
//  Created by Raphaël Calabro on 07/08/2017.
//  Copyright © 2017 Raphaël Calabro. All rights reserved.
//

import Foundation

struct StraightShootingStyleDefinition : ShootingStyleDefinition {
    
    var shotAmount: Int
    var shotAmountVariation: Int
    
    var shotSpeed: GLfloat
    var shootInterval: TimeInterval
    
    var inversions: ShootingStyleInversion
    var inversionInterval: Int
    
    var spriteDefinition: Int
    
    /// Espace entre chaque tir.
    var space: GLfloat
    
    func shootingStyle(spriteFactory: SpriteFactory) -> ShootingStyle {
        return StraightShootingStyle(definition: self, spriteFactory: spriteFactory)
    }
    
}

class StraightShootingStyle : ShootingStyle {
    
    var straightDefinition: StraightShootingStyleDefinition {
        return self.definition as! StraightShootingStyleDefinition
    }
    
    override func shots(from point: Point<GLfloat>, angle: GLfloat, type: SpriteType) -> [Sprite] {
        var shots = [Sprite]()
        
        var spriteDefinition = spriteFactory.definitions[definition.spriteDefinition]
        spriteDefinition.type = type
        
        var left = point.x - (GLfloat(shotAmount - 1) * straightDefinition.space) / 2
        for _ in 0 ..< shotAmount {
            let speed = Point<GLfloat>(x: cosf(angle) * definition.shotSpeed,
                                       y: sinf(angle) * definition.shotSpeed)
            let shot = spriteFactory.sprite(spriteDefinition)
            shot.frame = Rectangle(x: left, y: point.y, width: 16, height: 16)
            shot.motion = ShotMotion(speed: speed)
            shot.hitbox = CenteredSpriteHitbox(sprite: shot, size: Size(width: shot.frame.width * 0.6666, height: shot.frame.height * 0.6666))
            
            shots.append(shot)
            
            left += straightDefinition.space
        }
        
        return shots
    }
    
}
