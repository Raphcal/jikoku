//
//  SpriteType.swift
//  Yamato
//
//  Created by Raphaël Calabro on 19/07/2017.
//  Copyright © 2017 Raphaël Calabro. All rights reserved.
//

import Melisse

enum SpriteType : Melisse.SpriteType {
    
    case decoration, player, enemy, friendlyShot, enemyShot

    var isCollidable: Bool {
        return self != .decoration
    }
    
}
