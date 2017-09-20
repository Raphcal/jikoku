//
//  Weapon.swift
//  Jikoku
//
//  Created by Raphaël Calabro on 04/09/2017.
//  Copyright © 2017 Raphaël Calabro. All rights reserved.
//

import Foundation
import Melisse
import GLKit

protocol Weapon : HasBlueprints {
    var level: Int { get }
    var shootingStyleDefinitions: [ShootingStyleDefinition] { get }

    func shootingStyle(factory: SpriteFactory) -> ShootingStyle
}

extension Weapon {
    func shootingStyle(factory: SpriteFactory) -> ShootingStyle {
        return CompositeShootingStyle(styles: shootingStyleDefinitions.map { $0.shootingStyle(spriteFactory: factory) })
    }
}

struct PulseWeapon : Weapon {
    
    var level: Int
    var shootingStyleDefinitions: [ShootingStyleDefinition]
    
    var blueprints = [
        SpriteBlueprint(paintedShapes: [
            PaintedShape(shape: .roundedArrow, paint: Color<GLubyte>(hex: 0x44B6DE))
            ], size: Size(width: 16, height: 24)),
        SpriteBlueprint(paintedShapes: [
            PaintedShape(shape: .powerWave, paint: Color<GLubyte>(hex: 0x44B6DE))
            ], size: Size(width: 16, height: 24))
    ]
    var spriteDefinitions = [Int]()
    
    init(level: Int) {
        self.level = level
        
        switch level {
        default:
            self.shootingStyleDefinitions = [
                StraightShootingStyleDefinition(shotAmount: 2, spriteDefinition: spriteDefinitions[0], space: 16),
                StraightShootingStyleDefinition(shotAmount: 1, spriteDefinition: spriteDefinitions[1], space: 0)
            ]
        }
    }
    
}

struct SpreadWeapon : Weapon {
    
    var level: Int
    var shootingStyleDefinitions: [ShootingStyleDefinition]
    
    var blueprints = [
        SpriteBlueprint(paintedShapes: [
            PaintedShape(shape: .round, paint: Color<GLubyte>(hex: 0x44B6DE))
            ], size: Size(size: 12))
    ]
    var spriteDefinitions = [Int]()
    
    init(level: Int) {
        self.level = level

        switch level {
        default:
            self.shootingStyleDefinitions = [CircularShootingStyleDefinition(shotAmount: 4, spriteDefinition: spriteDefinitions[0], baseAngle: -3 * .pi / 24, angleIncrement: .pi / 12)]
        }
    }
}

struct CrossWeapon : Weapon {
    
    var level: Int
    var shootingStyleDefinitions: [ShootingStyleDefinition]

    var blueprints = [
        SpriteBlueprint(paintedShapes: [
            PaintedShape(shape: .arrow, paint: Color<GLubyte>(hex: 0x44B6DE))
            ], size: Size(width: 16, height: 24)),
        SpriteBlueprint(paintedShapes: [
            PaintedShape(shape: .arrow, paint: Color<GLubyte>(hex: 0x44B6DE))
            ], size: Size(width: 24, height: 36))
    ]
    var spriteDefinitions = [Int]()
    
    init(level: Int) {
        self.level = level
        
        switch level {
        default:
            self.shootingStyleDefinitions = [
                CircularShootingStyleDefinition(shotAmount: 4, shootInterval: 0.05, inversions: [.angle], inversionInterval: 8, spriteDefinition: spriteDefinitions[0], baseAngle: -.pi / 4, baseAngleVariation: .pi / 24)
            ]
        }
    }
}

// TODO: Implémenter le shooting-style laser/ray
struct LaserWeapon : Weapon {
    var level: Int

    var shootingStyleDefinitions: [ShootingStyleDefinition]
    
    var blueprints: [SpriteBlueprint]
    var spriteDefinitions = [Int]()
}
