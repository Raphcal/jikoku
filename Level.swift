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

    var bossDefinition: Int?
    var bossShadowDefinition: Int?
    var bossShotDefinition: Int?
    
    var weapons: [String]
    
    static func random(with kanjis: [Kanji]) -> Level {
        let waves = (0 ..< 10).map {_ in Wave.random(with: kanjis) }
        var kanas = waves.kanas
        
        return Level(
            waves: waves,
            boss: Boss.simple,
            bossDefinition: nil,
            bossShadowDefinition: nil,
            bossShotDefinition: nil,
            weapons: (0 ..< 5).map { _ in kanas.removeAtRandom() })
    }
}

extension Array where Element == Wave {
    var kanas: [String] {
        var set = Set<String>()
        set.insert("ひ")
        set.insert("ヨ")
        set.insert("ウ")
        for wave in self {
            for group in wave.groups {
                for reading in group.kanji.readings {
                    for character in reading {
                        set.insert(String(character))
                    }
                }
            }
        }
        return [String](set)
    }
}
