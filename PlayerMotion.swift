//
//  PlayerMotion.swift
//  Yamato
//
//  Created by Raphaël Calabro on 21/07/2017.
//  Copyright © 2017 Raphaël Calabro. All rights reserved.
//

import Foundation
import Melisse
import UIKit

fileprivate let maxSpeed: GLfloat = 500

class PlayerMotion : Motion {
    
    let panGestureRecognizer: UIPanGestureRecognizer
    let view: UIView?
    
    let spriteFactory: SpriteFactory
    
    var oldTranslation = Point<GLfloat>()
    var translation = Point<GLfloat>()
    
    var shootingStyles: [ShootingStyle]
    var currentShootingStyle = 0
    var shootingStyle: ShootingStyle {
        return shootingStyles[currentShootingStyle]
    }
    
    init(panGestureRecognizer: UIPanGestureRecognizer, spriteFactory: SpriteFactory) {
        self.panGestureRecognizer = panGestureRecognizer
        self.view = Director.instance?.viewController?.view
        self.spriteFactory = spriteFactory
        self.shootingStyles = [
            StraightShootingStyle(definition: StraightShootingStyleDefinition(
                shotAmount: 2,
                shotAmountVariation: 0,
                shotSpeed: 500,
                shootInterval: 0.1,
                baseAngle: toRadian(-90),
                inversions: [],
                inversionInterval: 0,
                spriteDefinition: 5,
                space: 32), spriteFactory: spriteFactory)
        ]
        
        panGestureRecognizer.addTarget(self, action: #selector(PlayerMotion.panGestureRecognized(by:)))
    }
    
    func load(_ sprite: Sprite) {
        sprite.hitbox = PlayerHitbox(sprite: sprite, size: Size(width: 8, height: 8))
    }
    
    func updateWith(_ timeSinceLastUpdate: TimeInterval, sprite: Sprite) {
        var move = translation - oldTranslation
        oldTranslation = translation
        
        let delta = GLfloat(timeSinceLastUpdate)
        move.x = move.x == 0 ? 0 : move.x / abs(move.x) * min(abs(move.x), delta * maxSpeed)
        move.y = move.y == 0 ? 0 : move.y / abs(move.y) * min(abs(move.y), delta * maxSpeed)
        
        sprite.frame.center += move
        
        shootingStyle.shoot(from: sprite, origin: .up, since: timeSinceLastUpdate)
        
        for other in spriteFactory.groups["enemy"] ?? [] {
            if sprite.hitbox.collides(with: other.hitbox) {
                sprite.destroy()
                NotificationCenter.default.post(name: PlayerDiedNotification, object: nil)
            }
        }
    }
    
    @objc func panGestureRecognized(by sender: UIPanGestureRecognizer) {
        if sender.state == .began {
            oldTranslation = Point()
        }
        let translation = sender.translation(in: self.view)
        self.translation = Point(x: GLfloat(translation.x), y: GLfloat(translation.y))
    }
    
}
