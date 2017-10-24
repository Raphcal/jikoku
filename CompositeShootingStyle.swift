//
//  CompositeShootingStyle.swift
//  Jikoku
//
//  Created by Raphaël Calabro on 04/09/2017.
//  Copyright © 2017 Raphaël Calabro. All rights reserved.
//

import Foundation
import GLKit
import Melisse

struct CompositeShootingStyleDefinition : ShootingStyleDefinition {
    var definitions: [ShootingStyleDefinition]
    
    func shootingStyle(spriteFactory: SpriteFactory) -> ShootingStyle {
        return CompositeShootingStyle(styles: definitions.map { $0.shootingStyle(spriteFactory: spriteFactory) })
    }
}

struct CompositeShootingStyle : ShootingStyle {
    
    var styles: [ShootingStyle]
    
    func shoot(from sprite: Sprite, angle: GLfloat, since lastUpdate: TimeInterval) {
        for style in styles {
            style.shoot(from: sprite, angle: angle, since: lastUpdate)
        }
    }
    
}
