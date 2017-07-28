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
    
    static func random(with kanjis: [Character]) -> Group {
        let size = ShapeSize.random
        return Group(
            kanji: Melisse.random(itemFrom: kanjis),
            count: size.randomCount,
            shape: .random,
            size: size,
            formation: .stationary,
            shootingStyleDefinition: StraightShootingStyleDefinition(
                shotAmount: 1,
                shotAmountVariation: 0,
                shotSpeed: 500,
                shootInterval: 0.25,
                baseAngle: .pi / 2,
                inversions: [],
                inversionInterval: 0,
                spriteDefinition: 1,
                space: 0))
    }
}
