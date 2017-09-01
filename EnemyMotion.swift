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

class EnemyMotion : BaseMotion, HasLifePoints {
    
    var lifePoints: Int {
        didSet {
            lifeBar?.value = lifePoints
        }
    }
    var lifeBar: LifeBar? {
        didSet {
            lifeBar?.maximum = lifePoints
            lifeBar?.value = lifePoints
        }
    }
    
    var angle = GLfloat.pi / 2
    
    var shootingStyles = [ShootingStyle]()

    let gameScene: GameScene
    let spriteFactory: TranslucentSpriteFactory
    
    var isDead = false
    
    init(lifePoints: Int, gameScene: GameScene) {
        self.lifePoints = lifePoints
        self.gameScene = gameScene
        self.spriteFactory = gameScene.spriteFactory
    }
    
    func load(_ sprite: Sprite) {
        // Rien à charger. Existe pour permettre aux sous classes de l'implémenter.
    }
    
    func updateWith(_ timeSinceLastUpdate: TimeInterval, sprite: Sprite) {
        if sprite.isRemoved {
            return
        }
        for other in spriteFactory.sprites {
            if let type = other.type as? SpriteType, type == SpriteType.friendlyShot && other.collides(with: sprite) {
                let group = sprite.group!
                let shotMotion = other.motion as! ShotMotion
                
                let reading = group.kanji.firstReading(including: shotMotion.kana)
                let multiplier: Int
                
                if let reading = reading {
                    multiplier = 4
                    show(reading: reading, movingAlong: other, tint: shotMotion.kana)
                } else {
                    multiplier = 1
                }
                
                other.destroy()
                
                lifePoints -= shotMotion.damage * multiplier
                
                if lifePoints <= 0 && !sprite.isRemoved {
                    if reading == nil {
                        show(reading: random(itemFrom: group.kanji.readings), movingAlong: sprite, tint: shotMotion.kana)
                    }
                    sprite.destroy()
                }
            }
        }
    }
    
    private func show(reading: String, movingAlong sprite: Sprite, tint kana: String) {
        // Calcul de la vitesse du texte
        let oldCenter = sprite.frame.center
        sprite.motion.updateWith(0.1, sprite: sprite)
        var speed = (sprite.frame.center - oldCenter) * 10
        speed.x = min(abs(speed.x), 50) * (speed.x != 0 ? speed.x / abs(speed.x) : 1)
        speed.y = min(abs(speed.y), 50) * (speed.y != 0 ? speed.y / abs(speed.y) : 1)
        
        // Lecture du kanji
        let text = Text(text: reading, font: KanaFont.default, factory: spriteFactory, point: Point(x: sprite.frame.x, y: sprite.frame.top))
        text.alignment = .center
        
        for sprite in text.sprites {
            var motion = DriftingMotion(speed: speed)
            if kana == sprite.definition.name {
                motion.color = .red
            }
            sprite.motion = motion
        }
    }
    
}
