//
//  Boss.swift
//  Yamato
//
//  Created by Raphaël Calabro on 28/07/2017.
//  Copyright © 2017 Raphaël Calabro. All rights reserved.
//

import Foundation

/// Type de boss.
enum Boss : Enumerable {
    /// Constitué de 2 kanjis qui ont une lecture irrégulière (par exemple : 今 et 日 qui deviennent 今日). Ils se séparent et s'assemblent afin de changer de lecture et éviter les tirs.
    case irregularReading
    
    /// Un ennemi double face avec un sens contraire sur chaque face (par exemple : 白/黒 ou 明/暗).
    case antonym
    
    /// Un ennemi qui change de taille et de kanji (par exemple : 大/小 ou 増/減). Quand gros, tirs puissants. Quand petit, déplacement rapide.
    case bigSmall
    
    /// Un ennemi central avec un sens regroupant le sens de plusieurs autres petits kanjis qui tournent autour (par exemple : 虹 + 赤黄緑青紫 ou 百 + 一二三四五). L'ennemi central ne tire pas tant qu'il reste des satellites. Les satellites tournent en cercle. Le cercle s'élargit et rétrécie. Les satellites tirent l'un à l'extérieur, l'autre à l'extérieur quand le cercle s'agrandit.
    case rainbow
    
    static let all = [Boss.irregularReading, .antonym, .bigSmall, .rainbow]
}
