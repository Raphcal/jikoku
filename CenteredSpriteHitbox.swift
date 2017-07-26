//
//  CenteredSpriteHitbox.swift
//  Yamato
//
//  Created by Raphaël Calabro on 26/07/2017.
//  Copyright © 2017 Raphaël Calabro. All rights reserved.
//

import Melisse

struct CenteredSpriteHitbox : Hitbox {
    
    var sprite: Sprite
    var size: Size<GLfloat>
    
    var frame: Rectangle<GLfloat> {
        return Rectangle(center: sprite.frame.center, size: size)
    }
    
}
