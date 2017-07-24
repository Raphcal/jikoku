//
//  EnemyMotion.swift
//  Yamato
//
//  Created by Raphaël Calabro on 24/07/2017.
//  Copyright © 2017 Raphaël Calabro. All rights reserved.
//

import Foundation
import Melisse
import GLKit

class EnemyMotion : Motion {
    
    var lifePoints: Int
    var spriteFactory: SpriteFactory
    
    init(lifePoints: Int, spriteFactory: SpriteFactory) {
        self.lifePoints = lifePoints
        self.spriteFactory = spriteFactory
    }
    
    func updateWith(_ timeSinceLastUpdate: TimeInterval, sprite: Sprite) {
        for other in spriteFactory.sprites {
            if let type = other.type as? SpriteType, type == SpriteType.friendlyShot && other.collides(with: sprite) {
                other.destroy()
                // TODO: Gérer le cas où le tir fait parti de la lecture du kanji
                lifePoints -= 1
                if lifePoints <= 0 {
                    sprite.destroy()
                    return
                }
            }
        }
    }
    
}

class StationaryEnemyMotion : EnemyMotion {
    
    var state = State.entering
    
    override func updateWith(_ timeSinceLastUpdate: TimeInterval, sprite: Sprite) {
        super.updateWith(timeSinceLastUpdate, sprite: sprite)
        
        switch state {
        case .entering:
            break
        case .stationary:
            break
        }
    }
    
    enum State {
        case entering, stationary
    }
    
}
