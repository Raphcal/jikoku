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
    
    var level: Level
    let spriteFactory: SpriteFactory
    var gameScene: GameScene? {
        didSet {
            if let gameScene = gameScene {
                formationManager = FormationManager(gameScene: gameScene)
            }
        }
    }
    
    var formationManager: FormationManager?
    
    var interval: TimeInterval = 0
    
    var nextWave = 0
    var bossHasArrived = false
    
    var sprites = [Sprite]()
    var breathInterval: TimeInterval = 0
    
    var enemyCount: Int {
        return sprites.reduce(sprites.count, { $1.isRemoved ? $0 - 1 : $0 })
    }
    
    var nonPersistentEnemyCount: Int {
        return sprites.reduce(sprites.count, { $1.group!.isPersistent || $1.isRemoved ? $0 - 1 : $0 })
    }
    
    init(level: Level, spriteFactory: SpriteFactory) {
        self.level = level
        self.spriteFactory = spriteFactory
    }
    
    func update(with timeSinceLastUpdate: TimeInterval) {
        if self.nextWave < level.waves.count {
            self.updateWaves(with: timeSinceLastUpdate)
        } else {
            self.updateBoss(with: timeSinceLastUpdate)
        }
    }
    
    fileprivate func updateWaves(with timeSinceLastUpdate: TimeInterval) {
        guard let formationManager = formationManager else {
            return
        }
        let noMoreEnemy = self.nonPersistentEnemyCount == 0
        if noMoreEnemy && breathInterval > 0 {
            breathInterval -= timeSinceLastUpdate
        }
        else if noMoreEnemy && self.nextWave < level.waves.count {
            let wave = level.waves[self.nextWave]
            self.nextWave += 1
            print("Vague n°\(self.nextWave)")
            
            formationManager.groups = wave.groups
            
            self.breathInterval = 1
        }
        
        let sprites = formationManager.update(since: timeSinceLastUpdate)
        if !sprites.isEmpty {
            self.sprites.append(contentsOf: sprites)
            print("\(sprites.count) nouveaux ennemis")
        }
    }
    
    fileprivate func updateBoss(with timeSinceLastUpdate: TimeInterval) {
        let noMoreEnemy = self.enemyCount == 0
        if noMoreEnemy && breathInterval > 0 {
            breathInterval -= timeSinceLastUpdate
        }
        else if noMoreEnemy && !bossHasArrived, let gameScene = gameScene {
            let boss = spriteFactory.sprite(level.bossDefinition!)
            
            var frame = boss.frame
            frame.center.x = View.instance.width / 2
            frame.bottom = -frame.height / 2
            boss.frame = frame
            
            let motion = SimpleBossMotion(lifePoints: 2000, gameScene: gameScene)
            motion.level = level
            boss.motion = motion
            motion.load(boss)
            
            sprites.append(boss)
            
            let lifeBar = LifeBar(plane: gameScene.plane)
            lifeBar.frame = Rectangle(left: 8, top: 24, width: View.instance.width - 16, height: 8)
            motion.lifeBar = lifeBar
            
            bossHasArrived = true
        }
        else if noMoreEnemy && bossHasArrived {
            // TODO: Fin du niveau
        }
    }
    
}
