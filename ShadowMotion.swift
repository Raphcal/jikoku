//
//  ShadowMotion.swift
//  Yamato
//
//  Created by Raphaël Calabro on 11/08/2017.
//  Copyright © 2017 Raphaël Calabro. All rights reserved.
//

import Foundation
import Melisse
import GLKit

struct ShadowMotion : Motion {

    var reference: Sprite
    
    func updateWith(_ timeSinceLastUpdate: TimeInterval, sprite: Sprite) {
        sprite.frame.center = Point(x: (reference.frame.x - View.instance.width / 2) * 1.2 + View.instance.width / 2, y: reference.frame.y * 1.01 + 16)
        
        if reference.isRemoved {
            sprite.destroy()
        }
    }
    
}
