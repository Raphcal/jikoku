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
    
    init(shotAmount: Int, shotAmountVariation: Int = 0, shotSpeed: GLfloat, shootInterval: TimeInterval, inversions: ShootingStyleInversion = [], inversionInterval: Int = 0, spriteDefinition: Int = 0, targetType: SpriteType) {
        self.shotAmount = shotAmount
        self.shotAmountVariation = shotAmountVariation
        self.shotSpeed = shotSpeed
        self.shootInterval = shootInterval
        self.inversions = inversions
        self.inversionInterval = inversionInterval
        self.spriteDefinition = spriteDefinition
        self.targetType = targetType
    }
    
    func shootingStyle(spriteFactory: SpriteFactory) -> ShootingStyle {
        return AimedShootingStyle(definition: self, spriteFactory: spriteFactory)
    }
    
}

class AimedShootingStyle : ShootingStyle {
    
    var aimedDefinition: AimedShootingStyleDefinition {
        return definition as! AimedShootingStyleDefinition
    }
    
    var targets: [Sprite] {
        let targetType = aimedDefinition.targetType
        return spriteFactory.groups[targetType.group]?.filter { $0.definition.type as! SpriteType == targetType } ?? []
    }
    
    override func shots(from point: Point<GLfloat>, angle: GLfloat, type: SpriteType) -> [Sprite] {
        var shots = [Sprite]()
        
        var spriteDefinition = spriteFactory.definitions[definition.spriteDefinition]
        spriteDefinition.type = type
        
        for _ in 0 ..< shotAmount {
            let angleToTarget: GLfloat
            let targets = self.targets
            if !targets.isEmpty {
                let target = random(itemFrom: targets)
                angleToTarget = target.frame.center.angleTo(point)
            } else {
                angleToTarget = angle
            }
            
            let speed = Point<GLfloat>(x: cosf(angleToTarget) * definition.shotSpeed,
                                       y: sinf(angleToTarget) * definition.shotSpeed)
            let shot = spriteFactory.sprite(spriteDefinition)
            shot.frame.center = point
            shot.motion = ShotMotion(angle: angleToTarget, speed: speed)
            shot.hitbox = CenteredSpriteHitbox(sprite: shot, size: Size(width: shot.frame.width * 0.6666, height: shot.frame.height * 0.6666))
            
            shots.append(shot)
        }
        
        return shots
    }
    
}
