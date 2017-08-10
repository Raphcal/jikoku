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

class EnemyMotion : BaseMotion {
    
    var lifePoints: Int
    var angle = GLfloat.pi / 2
    
    var shootingStyles = [ShootingStyle]()

    let gameScene: GameScene
    let spriteFactory: SpriteFactory
    
    var isDead = false
    
    init(lifePoints: Int, gameScene: GameScene) {
        self.lifePoints = lifePoints
        self.gameScene = gameScene
        self.spriteFactory = gameScene.spriteFactory
    }
    
    func load(_ sprite: Sprite) {
        // Rien à charger. Présent pour permettre aux sous classes de pouvoir l'implémenter.
    }
    
    func updateWith(_ timeSinceLastUpdate: TimeInterval, sprite: Sprite) {
        if sprite.isRemoved {
            return
        }
        for other in spriteFactory.sprites {
            if let type = other.type as? SpriteType, type == SpriteType.friendlyShot && other.collides(with: sprite) {
                other.destroy()
                // TODO: Gérer le cas où le tir fait parti de la lecture du kanji
                lifePoints -= 1
                if lifePoints <= 0 && !sprite.isRemoved {
                    sprite.destroy()
                    
                    let oldCenter = sprite.frame.center
                    self.updateWith(0.1, sprite: sprite)
                    let speed = (sprite.frame.center - oldCenter) * 5
                    
                    if let group = sprite.objects["group"] as? Group {
                        let text = Text(text: random(itemFrom: group.kanji.readings), font: KanaFont.default, factory: spriteFactory, point: Point(x: sprite.frame.x, y: sprite.frame.top))
                        text.alignment = .center
                        
                        for sprite in text.sprites {
                            sprite.motion = DriftingMotion(speed: speed)
                        }
                    }
                }
            }
        }
    }
    
}
