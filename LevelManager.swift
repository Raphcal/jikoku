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
    var gameScene: GameScene? {
        didSet {
            if let gameScene = gameScene {
                formationManager = FormationManager(gameScene: gameScene)
            }
        }
    }
    
    var formationManager: FormationManager?
    
    var interval: TimeInterval = 0
    
    var state = State.beforeWave
    var wave = 0
    
    var sprites = [Sprite]()
    var breathInterval: TimeInterval = 0
    
    var enemyCount: Int {
        return sprites.reduce(sprites.count, { $1.isRemoved ? $0 - 1 : $0 })
    }
    
    init(level: Level, spriteFactory: SpriteFactory) {
        self.level = level
        self.spriteFactory = spriteFactory
    }
    
    func update(with timeSinceLastUpdate: TimeInterval) {
        guard let formationManager = formationManager else {
            return
        }
        let noMoreEnemy = self.enemyCount == 0
        if noMoreEnemy && breathInterval > 0 {
            breathInterval -= timeSinceLastUpdate
        }
        else if noMoreEnemy && self.wave < level.waves.count {
            let wave = level.waves[self.wave]
            self.wave += 1
            print("Vague n°\(self.wave)")
            
            formationManager.groups = wave.groups
            
            self.breathInterval = 1
        }
        
        let sprites = formationManager.update(since: timeSinceLastUpdate)
        if !sprites.isEmpty {
            self.sprites.append(contentsOf: sprites)
            print("\(sprites.count) nouveaux ennemis")
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
