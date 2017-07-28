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
    
    init(waves: [Wave], boss: Boss) {
        self.waves = waves
        self.boss = boss
        
        var blueprints = [SpriteBlueprint]()
        for wave in waves {
            for group in wave.groups {
                blueprints.append(SpriteBlueprint(
                    shape: group.shape,
                    shapePaint: Color<GLubyte>(red: 255, green: 0, blue: 0, alpha: 255),
                    text: String(group.kanji),
                    textColor: Color<GLubyte>(red: 255, green: 255, blue: 255, alpha: 255),
                    size: Size(width: group.size.pixelSize, height: group.size.pixelSize))
                )
                // TODO: Ajouter les tirs
            }
        }
    }
    
    static func random(with kanjis: [Character]) -> Level {
        return Level(
            waves: (0 ..< 10).map {_ in Wave.random(with: kanjis) },
            boss: Boss.random)
    }
}

struct SpriteBlueprint {
    var shape: Shape?
    var shapePaint: Paint?
    var text: String?
    var textColor: Color<GLubyte>?
    var size: Size<GLfloat>
}

protocol Paint {
}

struct RadialGradient : Paint {
    var innerColor: Color<GLubyte>
    var outerColor: Color<GLubyte>
}

extension Color : Paint {
}
