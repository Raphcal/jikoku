//
//  Kanji.swift
//  Yamato
//
//  Created by Raphaël Calabro on 27/07/2017.
//  Copyright © 2017 Raphaël Calabro. All rights reserved.
//

import Foundation

struct Kanji {
    var character: Character
    var meanings: [String]
    var kunyomis: [String]
    var onyomis: [String]
    
    // 私一二三四五六七八九十百千万年月火水木金土曜日本元気白黒西北南東国小大人子男女母父中長高出入時行見午先後前生間上下今学校円外来山話読語書名川水雨半電聞食車何毎天右左友休早
    static let jlptN5 = [
        Kanji(character: "一", meanings: ["one"], kunyomis: ["ひと"], onyomis: ["イチ"]),
        Kanji(character: "二", meanings: ["two"], kunyomis: ["ふた"], onyomis: ["ニ", "ジ"]),
        Kanji(character: "三", meanings: ["three"], kunyomis: ["み", "みっ"], onyomis: ["サン", "ゾウ"]),
        Kanji(character: "四", meanings: ["four"], kunyomis: ["よ", "よん", "よっ"], onyomis: ["シ"]),
        Kanji(character: "五", meanings: ["five"], kunyomis: ["いつ"], onyomis: ["ゴ"]),
        Kanji(character: "六", meanings: ["six"], kunyomis: ["む", "むい", "むっ"], onyomis: ["ロク"]),
        Kanji(character: "七", meanings: ["seven"], kunyomis: ["なな", "なの"], onyomis: ["シチ"]),
        Kanji(character: "八", meanings: ["eight"], kunyomis: ["や", "やっ", "よう"], onyomis: ["ハチ"]),
        Kanji(character: "九", meanings: ["nine"], kunyomis: ["ここの"], onyomis: ["キュウ", "ク"]),
        Kanji(character: "十", meanings: ["ten"], kunyomis: ["とお", "と"], onyomis: ["ジュウ", "ジッ", "ジュッ"]),
        Kanji(character: "百", meanings: ["hundred"], kunyomis: ["もも"], onyomis: ["ヒャク", "ビャク"]),
        Kanji(character: "千", meanings: ["thousand"], kunyomis: ["ち"], onyomis: ["セン"]),
        Kanji(character: "万", meanings: ["ten thousand"], kunyomis: ["よろず"], onyomis: ["マン", "バン"]),
    ]
}
