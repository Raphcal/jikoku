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
    
    static func random(with kanjis: [Character]) -> Wave {
        return Wave(groups: (0 ..< Melisse.random(from: 1, to: 4)).map { _ in Group.random(with: kanjis) })
    }
}
