//
//  ShootingStyle.swift
//  Yamato
//
//  Created by Raphaël Calabro on 20/07/2017.
//  Copyright © 2017 Raphaël Calabro. All rights reserved.
//

import Melisse

/// Classe de base des styles de tir.
class ShootingStyle {
    
    let definition: ShootingStyleDefinition
    let spriteFactory: SpriteFactory
    
    var shootInterval: TimeInterval
    var shotAmount: Int
    var shotAmountVariation: Int
    
    var inversionInterval: Int = 0
    
    init(definition: ShootingStyleDefinition, spriteFactory: SpriteFactory) {
        self.definition = definition
        self.spriteFactory = spriteFactory

        self.shootInterval = definition.shootInterval
        self.shotAmount = definition.shotAmount
        self.shotAmountVariation = definition.shotAmountVariation
        self.inversionInterval = definition.inversionInterval
    }
    
    /// Fait tirer le sprite donné.
    func shoot(from sprite: Sprite, origin: Direction, since lastUpdate: TimeInterval) {
        if shootInterval > 0 {
            shootInterval -= lastUpdate
            return
        } else {
            shootInterval += definition.shootInterval
            
            _ = shots(from: origin.point(of: sprite.frame), type: sprite === GameScene.current?.player ? .friendlyShot : .enemyShot)
            
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
    
    /// Créé les sprites des tirs.
    func shots(from point: Point<GLfloat>, type: SpriteType) -> [Sprite] {
        return []
    }
    
    /// Exécute les inversions propres au style de tir.
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
    
    override func shots(from point: Point<GLfloat>, type: SpriteType) -> [Sprite] {
        var shots = [Sprite]()
        
        var spriteDefinition = spriteFactory.definitions[definition.spriteDefinition]
        spriteDefinition.type = type
        
        var left = point.x - (GLfloat(shotAmount - 1) * straightDefinition.space) / 2
        for _ in 0 ..< shotAmount {
            let speed = Point<GLfloat>(x: cosf(definition.baseAngle) * definition.shotSpeed,
                                       y: sinf(definition.baseAngle) * definition.shotSpeed)
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
