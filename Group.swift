//
//  Group.swift
//  Yamato
//
//  Created by Raphaël Calabro on 28/07/2017.
//  Copyright © 2017 Raphaël Calabro. All rights reserved.
//

import Foundation
import Melisse

struct Group : Hashable {
    
    var kanji: Character
    var count: Int
    var shape: Shape
    var size: ShapeSize
    var formation: Formation
    var spriteDefinition: Int?
    var shootingStyleDefinition: ShootingStyleDefinition?
    
    init(kanji: Character, count: Int, shape: Shape, size: ShapeSize, formation: Formation, spriteDefinition: Int? = nil, shootingStyleDefinition: ShootingStyleDefinition? = nil) {
        self.kanji = kanji
        self.count = count
        self.shape = shape
        self.size = size
        self.formation = formation
        self.spriteDefinition = spriteDefinition
        self.shootingStyleDefinition = shootingStyleDefinition
    }
    
    var hashValue: Int {
        return kanji.hashValue &* 3
            &+ count.hashValue &* 7
            &+ shape.hashValue &* 11
            &+ size.hashValue &* 13
            &+ formation.hashValue &* 17
    }
    
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
    
    static func ==(lhs: Group, rhs: Group) -> Bool {
        return lhs.kanji == rhs.kanji
            && lhs.count == rhs.count
            && lhs.shape == rhs.shape
            && lhs.size == rhs.size
            && lhs.formation == rhs.formation
    }
}
