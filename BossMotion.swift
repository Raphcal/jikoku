//
//  BossMotion.swift
//  Jikoku
//
//  Created by Raphaël Calabro on 21/08/2017.
//  Copyright © 2017 Raphaël Calabro. All rights reserved.
//

import Foundation
import Melisse
import GLKit

class SimpleBossMotion : StationaryEnemyMotion {
    
    var level: Level?
    
    override func load(_ sprite: Sprite) {
        self.stationaryInterval = 120
        self.targetY = 15
        self.shootingStyles = [
            CircularShootingStyleDefinition(
                shotAmount: 24,
                shotAmountVariation: 0,
                shotSpeed: 100,
                shootInterval: 0.5,
                inversions: [.angle],
                inversionInterval: 12,
                spriteDefinition: level!.bossShotDefinition!,
                baseAngle: 0,
                baseAngleVariation: GLKMathDegreesToRadians(5)).shootingStyle(spriteFactory: sprite.factory)
        ]
    }
    
}
