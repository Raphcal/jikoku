//
//  SpriteType.swift
//  Jikoku
//
//  Created by Raphaël Calabro on 19/07/2017.
//  Copyright © 2017 Raphaël Calabro. All rights reserved.
//

import Melisse

enum SpriteType : Melisse.SpriteType {
    
    case decoration, player, enemy, friendlyShot, enemyShot

    var group: String {
        switch self {
        case .decoration:
            return "decoration"
        case .player:
            return "player"
        case .friendlyShot:
            return "friendlyShot"
        case .enemy:
            fallthrough
        case .enemyShot:
            return "enemy"
        }
    }
    
}
