//
//  Wave.swift
//  Yamato
//
//  Created by Raphaël Calabro on 28/07/2017.
//  Copyright © 2017 Raphaël Calabro. All rights reserved.
//

import Foundation
import Melisse

struct Wave {
    var groups: [Group]
    
    static func random(with kanjis: [Kanji]) -> Wave {
        var formations = [Formation.stationary, .topLeftQuarterCircle, .topRightQuarterCircle]
        return Wave(groups: (0 ..< Melisse.random(from: 1, to: 3)).map { _ in
            var group = Group.random(with: kanjis)
            group.formation = formations.removeAtRandom()
            return group
        })
    }
}
