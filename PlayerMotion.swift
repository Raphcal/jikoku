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
    
    let panSensitiveZone: PanSensitiveZone
    
    let spriteFactory: SpriteFactory
    
    var oldTranslation = Point<GLfloat>()
    var translation = Point<GLfloat>()
    
    var shootingStyle: ShootingStyle = NoShootingStyle()
    
    let angle = -GLfloat.pi / 2
    
    var invicibility: TimeInterval?
    
    init(spriteFactory: SpriteFactory) {
        self.spriteFactory = spriteFactory
        let view = View.instance
        self.panSensitiveZone = PanSensitiveZone(frame: Rectangle(left: 0, top: 0, width: view.width, height: view.height - 84), touches: TouchController.instance.touches)
    }
    
    func load(_ sprite: Sprite) {
        sprite.hitbox = CenteredSpriteHitbox(sprite: sprite, size: Size(width: 8, height: 8))
    }
    
    func updateWith(_ timeSinceLastUpdate: TimeInterval, sprite: Sprite) {
        panSensitiveZone.update(with: TouchController.instance.touches)
        
        var move = panSensitiveZone.translation
        
        let delta = GLfloat(timeSinceLastUpdate)
        move.x = move.x == 0 ? 0 : move.x / abs(move.x) * min(abs(move.x), delta * maxSpeed)
        move.y = move.y == 0 ? 0 : move.y / abs(move.y) * min(abs(move.y), delta * maxSpeed)
        
        var frame = sprite.frame
        frame.center += move
        if frame.left < 0 {
            frame.left = 0
        }
        else if frame.right > panSensitiveZone.frame.width {
            frame.right = panSensitiveZone.frame.width
        }
        if frame.top < 0 {
            frame.top = 0
        }
        else if frame.bottom > panSensitiveZone.frame.height {
            frame.bottom = panSensitiveZone.frame.height
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
    
}
