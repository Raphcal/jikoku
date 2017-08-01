//
//  LevelManager.swift
//  Yamato
//
//  Created by Raphaël Calabro on 24/07/2017.
//  Copyright © 2017 Raphaël Calabro. All rights reserved.
//

import Foundation
import Melisse

fileprivate let creationInterval: TimeInterval = 0.5

class LevelManager {
    
    let level: Level
    let spriteFactory: SpriteFactory
    var gameScene: GameScene?
    
    var interval: TimeInterval = 0
    
    var state = State.beforeWave
    var wave = 0
    
    var sprites = [Sprite]()
    
    init(level: Level, spriteFactory: SpriteFactory) {
        self.level = level
        self.spriteFactory = spriteFactory
    }
    
    func update(with timeSinceLastUpdate: TimeInterval) {
        // TODO: Gérer le niveau
        interval += timeSinceLastUpdate
        while interval > creationInterval {
            interval -= creationInterval
            
            let enemy = spriteFactory.sprite(random(from: 1, to: spriteFactory.definitions.count - 1))
            
            let motion: EnemyMotion
            switch random(3) {
            case 0:
                motion = StationaryEnemyMotion(lifePoints: 10, gameScene: gameScene!)
            case 1:
                motion = QuarterCircleEnemyMotion(lifePoints: 5, gameScene: gameScene!, center: Point())
            default:
                motion = QuarterCircleEnemyMotion(lifePoints: 5, gameScene: gameScene!, center: Point(x: View.instance.width, y: 0))
            }
            enemy.motion = motion
            motion.load(enemy)
        }
    }
    
    private func updateBeforeWave(since lastUpdate: TimeInterval) {
        let wave = level.waves[0]
        for group in wave.groups {
            sprites = (0 ..< group.count).map { _ in
                let sprite = spriteFactory.sprite(random(from: 1, to: kanjis.characters.count - 1))
                
                return sprite
            }
        }
        
        state = .wave
    }
    
    enum State {
        case beforeWave, wave
    }
    
}
