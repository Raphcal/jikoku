//
//  Level.swift
//  Yamato
//
//  Created by Raphaël Calabro on 24/07/2017.
//  Copyright © 2017 Raphaël Calabro. All rights reserved.
//

import Foundation
import Melisse
import GLKit

struct Level {
    var waves: [Wave]
    var boss: Boss
    
    static func random(with kanjis: [Character]) -> Level {
        return Level(
            waves: (0 ..< 10).map {_ in Wave.random(with: kanjis) },
            boss: Boss.random)
    }
}
