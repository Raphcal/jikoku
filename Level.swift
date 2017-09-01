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
        var kanas = [
            "あ", "か", "さ", "た", "な", "は", "ま", "や", "ら", "わ",
            "い", "き", "し", "ち", "に", "ひ", "み", "り",
            "う", "く", "す", "つ", "ぬ", "ふ", "む", "ゆ", "る",
            "え", "け", "せ", "て", "ね", "へ", "め", "れ",
            "お", "こ", "そ", "と", "の", "ほ", "も", "よ", "ろ", "を",
            "ん"]
        
        return Level(
            waves: (0 ..< 10).map {_ in Wave.random(with: kanjis) },
            boss: Boss.simple,
            bossDefinition: nil,
            bossShadowDefinition: nil,
            bossShotDefinition: nil,
            weapons: (0 ..< 5).map { _ in kanas.removeAtRandom() })
    }
}
