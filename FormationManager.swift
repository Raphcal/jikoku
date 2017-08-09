//
//  FormationManager.swift
//  Yamato
//
//  Created by Raphaël Calabro on 02/08/2017.
//  Copyright © 2017 Raphaël Calabro. All rights reserved.
//

import Foundation
import Melisse

class FormationManager {
    
    let gameScene: GameScene
    let spriteFactory: SpriteFactory
    
    var groups = [Group]() {
        didSet {
            definitions = groups.map { $0.formationDefinition }
        }
    }
    var definitions = [FormationDefinition]() {
        didSet {
            intervals = [TimeInterval](repeating: 0, count: definitions.count)
            counts = [Int](repeating: 0, count: definitions.count)
        }
    }
    var intervals = [TimeInterval]()
    var counts = [Int]()
    
    init(gameScene: GameScene) {
        self.gameScene = gameScene
        self.spriteFactory = gameScene.spriteFactory
    }
    
    func update(since lastUpdate: TimeInterval) -> [Sprite] {
        var sprites = [Sprite]()
        for index in 0 ..< definitions.count {
            let definition = definitions[index]

            var interval = intervals[index] + lastUpdate
            if interval > definition.interval {
                interval -= definition.interval
                
                let group = groups[index]
                let points = definition.creationPoints
                let count = counts[index]
                let max = min(points.count, group.count - count)
                
                let lifePoints = group.size.lifePoints
                
                for i in 0 ..< max {
                    let sprite = spriteFactory.sprite(group.spriteDefinition!)
                    sprite.frame.center = points[i]
                    
                    let motion = group.formation.motion(lifePoints: lifePoints, gameScene: gameScene)
                    
                    if let shootingStyle = group.shootingStyleDefinition?.shootingStyle(spriteFactory: spriteFactory) {
                        motion.shootingStyles = [shootingStyle]
                    }
                    
                    sprite.motion = motion
                    motion.load(sprite)
                    
                    sprites.append(sprite)
                }
                
                counts[index] = count + max
            }
            intervals[index] = interval
        }
        return sprites
    }
    
}
