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

struct CircularShootingStyleDefinition : BaseShootingStyleDefinition {
    
    let origin = ShotOrigin.center
    
    var damage: Int
    
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
    
    /// Différence d'angle entre 2 tirs.
    var angleIncrement: GLfloat?
    
    init(damage: Int = 1, shotAmount: Int, shotAmountVariation: Int = 0, shotSpeed: GLfloat = 500, shootInterval: TimeInterval = 0.1, inversions: ShootingStyleInversion = [], inversionInterval: Int = 0, spriteDefinition: Int = 0, baseAngle: GLfloat = 0, baseAngleVariation: GLfloat = 0, angleIncrement: GLfloat? = nil) {
        self.damage = damage
        self.shotAmount = shotAmount
        self.shotAmountVariation = shotAmountVariation
        self.shotSpeed = shotSpeed
        self.shootInterval = shootInterval
        self.inversions = inversions
        self.inversionInterval = inversionInterval
        self.spriteDefinition = spriteDefinition
        self.baseAngle = baseAngle
        self.baseAngleVariation = baseAngleVariation
        self.angleIncrement = angleIncrement
    }
    
    func shootingStyle(spriteFactory: SpriteFactory) -> ShootingStyle {
        return CircularShootingStyle(definition: self, spriteFactory: spriteFactory)
    }
    
}

/// Tir un cercle de tirs
class CircularShootingStyle : BaseShootingStyle {
    
    var circularDefinition : CircularShootingStyleDefinition {
        return definition as! CircularShootingStyleDefinition
    }
    
    var baseAngle: GLfloat
    var baseAngleVariation: GLfloat
    
    override init(definition: BaseShootingStyleDefinition, spriteFactory: SpriteFactory) {
        let circularDefinition = (definition as! CircularShootingStyleDefinition)
        self.baseAngle = circularDefinition.baseAngle
        self.baseAngleVariation = circularDefinition.baseAngleVariation

        super.init(definition: definition, spriteFactory: spriteFactory)
    }
    
    override func shots(from point: Point<GLfloat>, angle: GLfloat, type: SpriteType, damage: Int) -> [Sprite] {
        var shots = [Sprite]()
        
        var spriteDefinition = spriteFactory.definitions[definition.spriteDefinition]
        spriteDefinition.type = type
        
        var currentAngle = angle + baseAngle
        let angleIncrement = circularDefinition.angleIncrement ?? GLfloat.pi * 2 / GLfloat(shotAmount)
        
        for _ in 0 ..< shotAmount {
            let speed = Point<GLfloat>(x: cosf(currentAngle) * definition.shotSpeed,
                                       y: sinf(currentAngle) * definition.shotSpeed)
            
            let shot = spriteFactory.sprite(spriteDefinition)
            shot.frame.center = point
            shot.motion = ShotMotion(angle: currentAngle, speed: speed, damage: damage)
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
