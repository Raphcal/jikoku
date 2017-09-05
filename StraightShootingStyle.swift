//
//  StraightShootingStyle.swift
//  Yamato
//
//  Created by Raphaël Calabro on 07/08/2017.
//  Copyright © 2017 Raphaël Calabro. All rights reserved.
//

import Foundation
import Melisse
import GLKit

struct StraightShootingStyleDefinition : BaseShootingStyleDefinition {
    
    let origin = ShotOrigin.front
    
    var damage: Int
    
    var shotAmount: Int
    var shotAmountVariation: Int
    
    var shotSpeed: GLfloat
    var shootInterval: TimeInterval
    
    var inversions: ShootingStyleInversion
    var inversionInterval: Int
    
    var spriteDefinition: Int
    
    /// Espace entre chaque tir.
    var space: GLfloat
    
    init(damage: Int = 1, shotAmount: Int, shotAmountVariation: Int = 0, shotSpeed: GLfloat = 500, shootInterval: TimeInterval = 0.1, inversions: ShootingStyleInversion = [], inversionInterval: Int = 0, spriteDefinition: Int = 0, space: GLfloat) {
        self.damage = damage
        self.shotAmount = shotAmount
        self.shotAmountVariation = shotAmountVariation
        self.shotSpeed = shotSpeed
        self.shootInterval = shootInterval
        self.inversions = inversions
        self.inversionInterval = inversionInterval
        self.spriteDefinition = spriteDefinition
        self.space = space
    }
    
    func shootingStyle(spriteFactory: SpriteFactory) -> ShootingStyle {
        return StraightShootingStyle(definition: self, spriteFactory: spriteFactory)
    }
    
}

/// Tir une rangé de tirs alignés horizontalement.
class StraightShootingStyle : BaseShootingStyle {
    
    var straightDefinition: StraightShootingStyleDefinition {
        return self.definition as! StraightShootingStyleDefinition
    }
    
    override func shots(from point: Point<GLfloat>, angle: GLfloat, type: SpriteType, damage: Int) -> [Sprite] {
        var shots = [Sprite]()
        
        var spriteDefinition = spriteFactory.definitions[definition.spriteDefinition]
        spriteDefinition.type = type
        
        var left = point.x - (GLfloat(shotAmount - 1) * straightDefinition.space) / 2
        for _ in 0 ..< shotAmount {
            let speed = Point<GLfloat>(x: cosf(angle) * definition.shotSpeed,
                                       y: sinf(angle) * definition.shotSpeed)
            let shot = spriteFactory.sprite(spriteDefinition)
            shot.frame.center = Point(x: left, y: point.y)
            shot.motion = ShotMotion(angle: angle, speed: speed, damage: damage)
            shot.hitbox = CenteredSpriteHitbox(sprite: shot, size: Size(width: shot.frame.width * 0.6666, height: shot.frame.height * 0.6666))
            
            shots.append(shot)
            
            left += straightDefinition.space
        }
        
        return shots
    }
    
}
