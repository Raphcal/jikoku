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
        // TODO: Ajouter le joueur
        for wave in waves {
            for group in wave.groups {
                // Sprite
                blueprints.append(SpriteBlueprint(
                    id: blueprints.count,
                    shape: group.shape,
                    shapePaint: Color<GLubyte>(red: 255, green: 0, blue: 0, alpha: 255),
                    text: String(group.kanji),
                    textColor: Color<GLubyte>(red: 255, green: 255, blue: 255, alpha: 255),
                    size: Size(width: group.size.pixelSize, height: group.size.pixelSize))
                )
                // Tir
                blueprints.append(SpriteBlueprint(
                    id: blueprints.count,
                    shape: .round,
                    shapePaint: Color<GLubyte>(red: 255, green: 255, blue: 255, alpha: 255),
                    text: nil,
                    textColor: nil,
                    size: Size(width: 16, height: 16))
                )
                // TODO: Sauvegarder quelque part les blueprints pour le groupe actuel
            }
        }
        // TODO: Ajouter les hiragana et katakana
    }
    
    static func random(with kanjis: [Character]) -> Level {
        return Level(
            waves: (0 ..< 10).map {_ in Wave.random(with: kanjis) },
            boss: Boss.random)
    }
}

struct SpriteBlueprint : Equatable {
    var id: Int
    var shape: Shape?
    var shapePaint: Paint?
    var text: String?
    var textColor: Color<GLubyte>?
    var size: Size<GLfloat>
    
    static func ==(lhs: SpriteBlueprint, rhs: SpriteBlueprint) -> Bool {
        return lhs.id == rhs.id
    }
}

protocol Paint {
}

struct RadialGradient : Paint {
    var innerColor: Color<GLubyte>
    var outerColor: Color<GLubyte>
}

extension Color : Paint {
}
