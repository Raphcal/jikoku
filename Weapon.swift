//
//  Weapon.swift
//  Jikoku
//
//  Created by Raphaël Calabro on 04/09/2017.
//  Copyright © 2017 Raphaël Calabro. All rights reserved.
//

import Foundation
import Melisse

protocol Weapon {
    var blueprints: [SpriteBlueprint] { get }
    func shootingStyle(for level: Int, factory: SpriteFactory) -> ShootingStyle
}

struct PulseWeapon : Weapon {
    
    var blueprints = [SpriteBlueprint]()
    
    func shootingStyle(for level: Int, factory: SpriteFactory) -> ShootingStyle {
        switch level {
        default:
            return NoShootingStyle()
        }
    }
}
