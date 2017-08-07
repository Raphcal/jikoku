//
//  Group.swift
//  Yamato
//
//  Created by Raphaël Calabro on 28/07/2017.
//  Copyright © 2017 Raphaël Calabro. All rights reserved.
//

import Foundation
import Melisse

struct Group {
    var kanji: Character
    var count: Int
    var shape: Shape
    var size: ShapeSize
    var formation: Formation
    var shootingStyleDefinition: ShootingStyleDefinition?
    
    var formationDefinition: FormationDefinition {
        switch formation {
        case .topLeftQuarterCircle:
            fallthrough
        case .topRightQuarterCircle:
            return QuarterCircleFormationDefinition(group: self)
        case .stationary:
            return StationaryFormationDefinition(group: self)
        default:
            return NoFormationDefinition()
        }
    }
    
    static func random(with kanjis: [Character]) -> Group {
        let size = ShapeSize.random
        let shootingStyleDefinition: ShootingStyleDefinition
        
        if size == .bigger {
            shootingStyleDefinition = CircularShootingStyleDefinition(
                shotAmount: 16,
                shotAmountVariation: 0,
                shotSpeed: 200,
                shootInterval: 0.5,
                inversions: [],
                inversionInterval: 0,
                spriteDefinition: 2,
                baseAngle: 0,
                baseAngleVariation: 0)
        } else {
            shootingStyleDefinition = StraightShootingStyleDefinition(
                shotAmount: 1,
                shotAmountVariation: 0,
                shotSpeed: 200,
                shootInterval: 1,
                inversions: [],
                inversionInterval: 0,
                spriteDefinition: 1,
                space: 0)
        }
        
        return Group(
            kanji: Melisse.random(itemFrom: kanjis),
            count: size.randomCount,
            shape: .random,
            size: size,
            formation: .stationary,
            shootingStyleDefinition: shootingStyleDefinition)
    }
}
