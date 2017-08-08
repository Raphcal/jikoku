//
//  Font.swift
//  Yamato
//
//  Created by Raphaël Calabro on 08/08/2017.
//  Copyright © 2017 Raphaël Calabro. All rights reserved.
//

import Melisse

struct KanaFontAnimationName : AnimationName {
    static let hiragana = KanaFontAnimationName(name: "hiragana")
    static let katakana = KanaFontAnimationName(name: "katakana")
    
    let name: String
}

struct KanaFont : Font {
    let hiraganaAnimation: AnimationName = KanaFontAnimationName.hiragana
    let katakanaAnimation: AnimationName = KanaFontAnimationName.katakana
}
