//
//  KanjiMotion.swift
//  Yamato
//
//  Created by Raphaël Calabro on 09/08/2017.
//  Copyright © 2017 Raphaël Calabro. All rights reserved.
//

import Foundation
import Melisse
import GLKit

class KanjiMotion : Motion {

    let spriteFactory: TranslucentSpriteFactory
    var alpha: GLfloat = 1
    
    init(spriteFactory: SpriteFactory) {
        self.spriteFactory = spriteFactory as! TranslucentSpriteFactory
    }
    
    func updateWith(_ timeSinceLastUpdate: TimeInterval, sprite: Sprite) {
        alpha = max(alpha - GLfloat(timeSinceLastUpdate), 0)
        spriteFactory.setAlpha(GLubyte(alpha * 255), of: sprite)
        
        sprite.frame.center.y -= 100 * GLfloat(timeSinceLastUpdate)
        
        if alpha == 0 {
            sprite.destroy()
        }
    }

}
