//
//  LevelManager.swift
//  Yamato
//
//  Created by Raphaël Calabro on 24/07/2017.
//  Copyright © 2017 Raphaël Calabro. All rights reserved.
//

import Foundation
import Melisse

class LevelManager {
    
    let level: Level
    let spriteFactory: SpriteFactory
    var gameScene: GameScene?
    
    let random = Random()
    
    var interval: TimeInterval = 0
    
    init(level: Level, spriteFactory: SpriteFactory) {
        self.level = level
        self.spriteFactory = spriteFactory
    }
    
    func update(with timeSinceLastUpdate: TimeInterval) {
        // TODO: Gérer le niveau
        interval += timeSinceLastUpdate
        while interval > 2 {
            interval -= 2
            
            let enemy = spriteFactory.sprite(random.next(spriteFactory.definitions.count - 1) + 1)
            let motion = StationaryEnemyMotion(lifePoints: 10, gameScene: gameScene!)
            enemy.motion = motion
            motion.load(enemy)
        }
    }
    
}
