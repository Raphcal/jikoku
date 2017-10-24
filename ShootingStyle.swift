//
//  ShootingStyle.swift
//  Yamato
//
//  Created by Raphaël Calabro on 20/07/2017.
//  Copyright © 2017 Raphaël Calabro. All rights reserved.
//

import Melisse
import GLKit

extension Rectangle where Coordinate == GLfloat {
    func point(at angle: GLfloat) -> Point<GLfloat> {
        return Point(x: center.x + size.width / 2 * cos(angle), y: center.y + size.height / 2 * sin(angle))
    }
}

protocol ShootingStyle {
    func shoot(from sprite: Sprite, angle: GLfloat, since lastUpdate: TimeInterval)
}

struct NoShootingStyle : ShootingStyle {
    func shoot(from sprite: Sprite, angle: GLfloat, since lastUpdate: TimeInterval) {
        // Pas de tir.
    }
}

/// Classe de base des styles de tir.
class BaseShootingStyle : ShootingStyle {
    
    let definition: BaseShootingStyleDefinition
    let spriteFactory: SpriteFactory
    
    var shootInterval: TimeInterval
    var shotAmount: Int
    var shotAmountVariation: Int
    
    var inversionInterval: Int = 0
    
    init(definition: BaseShootingStyleDefinition, spriteFactory: SpriteFactory) {
        self.definition = definition
        self.spriteFactory = spriteFactory

        self.shootInterval = random(from: 0, to: definition.shootInterval)
        self.shotAmount = definition.shotAmount
        self.shotAmountVariation = definition.shotAmountVariation
        self.inversionInterval = definition.inversionInterval
    }
    
    /// Fait tirer le sprite donné.
    func shoot(from sprite: Sprite, angle: GLfloat, since lastUpdate: TimeInterval) {
        if shootInterval > 0 {
            shootInterval -= lastUpdate
            return
        } else {
            shootInterval += definition.shootInterval
            
            let origin: Point<GLfloat>
            switch definition.origin {
            case .center:
                origin = sprite.frame.center
            case .front:
                origin = sprite.frame.point(at: angle)
            }
            
            // Salve de tir
            _ = self.shots(from: origin, angle: angle, type: sprite === GameScene.current?.player ? .friendlyShot : .enemyShot, damage: definition.damage)
            
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
    func shots(from point: Point<GLfloat>, angle: GLfloat, type: SpriteType, damage: Int) -> [Sprite] {
        return []
    }
    
    /// Exécute les inversions propres au style de tir.
    func invert() {
        if definition.inversions.contains(.amount) {
            shotAmountVariation = -shotAmountVariation
        }
    }

}
