//
//  Kanji.swift
//  Yamato
//
//  Created by Raphaël Calabro on 27/07/2017.
//  Copyright © 2017 Raphaël Calabro. All rights reserved.
//

import Foundation

struct Kanji : Enumerable, Hashable {
    var character: Character
    var meanings: [String: [String]]
    var kunyomis: [String]
    var onyomis: [String]
    var tags: [String]
    
    var hashValue: Int {
        return character.hashValue
    }
    
    // 私一二三四五六七八九十百千万年月火水木金土曜日本元気白黒西北南東国小大人子男女母父中長高出入時行見午先後前生間上下今学校円外来山話読語書名川水雨半電聞食車何毎天右左友休早
    static let all = [
        Kanji(character: "一", meanings: ["en": ["one"], "fr": ["un"]], kunyomis: ["ひと"], onyomis: ["イチ"], tags: ["jtlp-n5", "number"]),
        Kanji(character: "二", meanings: ["en": ["two"], "fr": ["deux"]], kunyomis: ["ふた"], onyomis: ["ニ", "ジ"], tags: ["jtlp-n5", "number"]),
        Kanji(character: "三", meanings: ["en": ["three"], "fr":["trois"]], kunyomis: ["み", "みっ"], onyomis: ["サン", "ゾウ"], tags: ["jtlp-n5", "number"]),
        Kanji(character: "四", meanings: ["en": ["four"], "fr":["quatre"]], kunyomis: ["よ", "よん", "よっ"], onyomis: ["シ"], tags: ["jtlp-n5", "number"]),
        Kanji(character: "五", meanings: ["en": ["five"], "fr":["cinq"]], kunyomis: ["いつ"], onyomis: ["ゴ"], tags: ["jtlp-n5", "number"]),
        Kanji(character: "六", meanings: ["en": ["six"], "fr":["six"]], kunyomis: ["む", "むい", "むっ"], onyomis: ["ロク"], tags: ["jtlp-n5", "number"]),
        Kanji(character: "七", meanings: ["en": ["seven"], "fr":["sept"]], kunyomis: ["なな", "なの"], onyomis: ["シチ"], tags: ["jtlp-n5", "number"]),
        Kanji(character: "八", meanings: ["en": ["eight"], "fr":["huit"]], kunyomis: ["や", "やっ", "よう"], onyomis: ["ハチ"], tags: ["jtlp-n5", "number"]),
        Kanji(character: "九", meanings: ["en": ["nine"], "fr":["neuf"]], kunyomis: ["ここの"], onyomis: ["キュウ", "ク"], tags: ["jtlp-n5", "number"]),
        Kanji(character: "十", meanings: ["en": ["ten"], "fr":["dix"]], kunyomis: ["とお", "と"], onyomis: ["ジュウ", "ジッ", "ジュッ"], tags: ["jtlp-n5", "number"]),
        Kanji(character: "百", meanings: ["en": ["hundred"], "fr":["cent"]], kunyomis: ["もも"], onyomis: ["ヒャク", "ビャク"], tags: ["jtlp-n5", "number"]),
        Kanji(character: "千", meanings: ["en": ["thousand"], "fr":["mille"]], kunyomis: ["ち"], onyomis: ["セン"], tags: ["jtlp-n5", "number"]),
        Kanji(character: "万", meanings: ["en": ["ten thousand"], "fr":["dix milles"]], kunyomis: ["よろず"], onyomis: ["マン", "バン"], tags: ["jtlp-n5", "number"]),
        Kanji(character: "年", meanings: ["en": ["year"], "fr":["année"]], kunyomis: ["とし"], onyomis: ["ネン"], tags: ["jtlp-n5", "date"]),
        Kanji(character: "月", meanings: ["en": ["moon", "month", "monday"], "fr":["lune", "mois", "lundi"]], kunyomis: ["つき"], onyomis: ["ゲツ", "ガツ"], tags: ["jtlp-n5", "date", "weekday"]),
    ]
    
    static func ==(lhs: Kanji, rhs: Kanji) -> Bool {
        return lhs.character == rhs.character
    }
}
