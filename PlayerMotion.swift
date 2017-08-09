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

class PlayerMotion : BaseMotion {
    
    let panGestureRecognizer: UIPanGestureRecognizer
    let view: UIView?
    
    let spriteFactory: SpriteFactory
    
    var oldTranslation = Point<GLfloat>()
    var translation = Point<GLfloat>()
    
    var shootingStyles: [ShootingStyle]
    
    let angle = -GLfloat.pi / 2
    
    var invicibility: TimeInterval?
    
    init(panGestureRecognizer: UIPanGestureRecognizer, spriteFactory: SpriteFactory) {
        self.panGestureRecognizer = panGestureRecognizer
        self.view = Director.instance?.viewController?.view
        self.spriteFactory = spriteFactory
        self.shootingStyles = [
            StraightShootingStyleDefinition(
                shotAmount: 2,
                shotAmountVariation: 0,
                shotSpeed: 500,
                shootInterval: 0.1,
                inversions: [],
                inversionInterval: 0,
                spriteDefinition: 1,
                space: 32).shootingStyle(spriteFactory: spriteFactory)
        ]
        
        panGestureRecognizer.addTarget(self, action: #selector(PlayerMotion.panGestureRecognized(by:)))
    }
    
    func load(_ sprite: Sprite) {
        sprite.hitbox = CenteredSpriteHitbox(sprite: sprite, size: Size(width: 8, height: 8))
    }
    
    func updateWith(_ timeSinceLastUpdate: TimeInterval, sprite: Sprite) {
        var move = translation - oldTranslation
        oldTranslation = translation
        
        let delta = GLfloat(timeSinceLastUpdate)
        move.x = move.x == 0 ? 0 : move.x / abs(move.x) * min(abs(move.x), delta * maxSpeed)
        move.y = move.y == 0 ? 0 : move.y / abs(move.y) * min(abs(move.y), delta * maxSpeed)
        
        var frame = sprite.frame
        frame.center += move
        if frame.left < 0 {
            frame.left = 0
        }
        else if frame.right > View.instance.width {
            frame.right = View.instance.width
        }
        if frame.top < 0 {
            frame.top = 0
        }
        else if frame.bottom > View.instance.height {
            frame.bottom = View.instance.height
        }
        sprite.frame = frame
        
        shoot(from: sprite, since: timeSinceLastUpdate)
        
        if var invicibility = invicibility {
            invicibility -= timeSinceLastUpdate
            self.invicibility = invicibility > 0 ? invicibility : nil
        } else {
            for other in spriteFactory.groups["enemy"] ?? [] {
                if sprite.hitbox.collides(with: other.hitbox) {
                    sprite.destroy()
                    NotificationCenter.default.post(name: PlayerDiedNotification, object: nil)
                }
            }
        }
    }
    
    func makeInvicible(sprite: Sprite, during interval: TimeInterval = 3) {
        invicibility = interval
        sprite.setBlinkingWith(duration: interval)
    }
    
    @objc func panGestureRecognized(by sender: UIPanGestureRecognizer) {
        if sender.state == .began {
            oldTranslation = Point()
        }
        let translation = sender.translation(in: self.view)
        self.translation = Point(x: GLfloat(translation.x), y: GLfloat(translation.y))
    }
    
}
