//
//  ShootingStyle.swift
//  Yamato
//
//  Created by Raphaël Calabro on 20/07/2017.
//  Copyright © 2017 Raphaël Calabro. All rights reserved.
//

import Melisse

class ShootingStyle {
    
    let definition: ShootingStyleDefinition
    let spriteFactory: SpriteFactory
    
    var shootInterval: TimeInterval = 0
    var shotAmount: Int
    var shotAmountVariation: Int
    
    var inversionInterval: Int = 0
    
    init(definition: ShootingStyleDefinition, spriteFactory: SpriteFactory) {
        self.definition = definition
        self.spriteFactory = spriteFactory

        self.shotAmount = definition.shotAmount
        self.shotAmountVariation = definition.shotAmountVariation
        self.inversionInterval = definition.inversionInterval
    }
    
    func shoot(from sprite: Sprite, origin: Direction, since lastUpdate: TimeInterval) {
        if shootInterval > 0 {
            shootInterval -= lastUpdate
            return
        } else {
            shootInterval += definition.shootInterval
            
            _ = shots(from: origin.point(of: sprite.frame))
            
            shotAmount += shotAmountVariation
            
            if !definition.inversions.isEmpty {
                if inversionInterval > 0 {
                    inversionInterval -= 1
                } else {
                    inversionInterval = definition.inversionInterval
                    invert()
                }
            }
        }
    }
    
    func shots(from point: Point<GLfloat>) -> [Sprite] {
        return []
    }
    
    func invert() {
        if definition.inversions.contains(.amount) {
            shotAmountVariation = -shotAmountVariation
        }
    }

}

class StraightShootingStyle : ShootingStyle {
    
    var straightDefinition: StraightShootingStyleDefinition {
        return self.definition as! StraightShootingStyleDefinition
    }
    
    override func shots(from point: Point<GLfloat>) -> [Sprite] {
        var shots = [Sprite]()
        
        var left = point.x - (GLfloat(shotAmount - 1) * straightDefinition.space) / 2
        for _ in 0 ..< shotAmount {
            let speed = Point<GLfloat>(x: cosf(definition.baseAngle) * definition.shotSpeed,
                                       y: sinf(definition.baseAngle) * definition.shotSpeed)
            let shot = spriteFactory.sprite(definition.spriteDefinition)
            shot.frame.center = Point(x: left, y: point.y)
            shot.motion = ShotMotion(speed: speed)
            
            shots.append(shot)
            
            left += straightDefinition.space
        }
        
        return shots
    }
    
}
