//
//  BaseMotion.swift
//  Yamato
//
//  Created by Raphaël Calabro on 01/08/2017.
//  Copyright © 2017 Raphaël Calabro. All rights reserved.
//

import Melisse
import GLKit

protocol BaseMotion : Motion {
    var angle: GLfloat { get }
    var shootingStyle: ShootingStyle { get }
}

extension BaseMotion {
    func shoot(from sprite: Sprite, since lastUpdate: TimeInterval) {
        shootingStyle.shoot(from: sprite, angle: angle, since: lastUpdate)
    }
}
