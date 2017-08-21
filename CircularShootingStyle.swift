//
//  CircularShootingStyle.swift
//  Yamato
//
//  Created by Raphaël Calabro on 07/08/2017.
//  Copyright © 2017 Raphaël Calabro. All rights reserved.
//

import Foundation
import Melisse
import GLKit

struct CircularShootingStyleDefinition : ShootingStyleDefinition {
    
    let origin = ShotOrigin.center
    
    var shotAmount: Int
    var shotAmountVariation: Int
    
    var shotSpeed: GLfloat
    var shootInterval: TimeInterval
    
    var inversions: ShootingStyleInversion
    var inversionInterval: Int
    
    var spriteDefinition: Int
    
    /// Angle de départ du premier tir.
    var baseAngle: GLfloat

    /// Variation de l'angle de départ.
    var baseAngleVariation: GLfloat
    
    func shootingStyle(spriteFactory: SpriteFactory) -> ShootingStyle {
        return CircularShootingStyle(definition: self, spriteFactory: spriteFactory)
    }
    
}

/// Tir un cercle de tirs
class CircularShootingStyle : ShootingStyle {
    
    var baseAngle: GLfloat
    var baseAngleVariation: GLfloat
    
    override init(definition: ShootingStyleDefinition, spriteFactory: SpriteFactory) {
        let circularDefinition = (definition as! CircularShootingStyleDefinition)
        self.baseAngle = circularDefinition.baseAngle
        self.baseAngleVariation = circularDefinition.baseAngleVariation

        super.init(definition: definition, spriteFactory: spriteFactory)
    }
    
    override func shots(from point: Point<GLfloat>, angle: GLfloat, type: SpriteType) -> [Sprite] {
        var shots = [Sprite]()
        
        var spriteDefinition = spriteFactory.definitions[definition.spriteDefinition]
        spriteDefinition.type = type
        
        var currentAngle = angle + baseAngle
        let angleIncrement = GLKMathDegreesToRadians(GLfloat(360 / shotAmount))
        
        for _ in 0 ..< shotAmount {
            let speed = Point<GLfloat>(x: cosf(currentAngle) * definition.shotSpeed,
                                       y: sinf(currentAngle) * definition.shotSpeed)
            
            let shot = spriteFactory.sprite(spriteDefinition)
            shot.frame.center = point
            shot.motion = ShotMotion(angle: currentAngle - .pi / 2, speed: speed)
            shot.hitbox = CenteredSpriteHitbox(sprite: shot, size: Size(width: shot.frame.width * 0.6666, height: shot.frame.height * 0.6666))
            
            shots.append(shot)
            
            currentAngle += angleIncrement
        }
        
        baseAngle += baseAngleVariation
        
        return shots
    }
    
    override func invert() {
        super.invert()
        
        if definition.inversions.contains(.angle) {
            baseAngleVariation = -baseAngleVariation
        }
    }
    
}
