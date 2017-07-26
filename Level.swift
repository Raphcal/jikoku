//
//  Level.swift
//  Yamato
//
//  Created by Raphaël Calabro on 24/07/2017.
//  Copyright © 2017 Raphaël Calabro. All rights reserved.
//

import Foundation
import Melisse

struct Level {
    var waves: [Wave]
    var boss: Boss
    
    static func random(with kanjis: [Character]) -> Level {
        var waves = [Wave]()
        for _ in 0 ..< 10 {
            var groups = [Group]()
            for _ in 0 ..< Melisse.random(from: 1, to: 4) {
                groups.append(Group(kanji: Melisse.random(itemFrom: kanjis), shape: .round, formation: .vertical, shootingStyleDefinition: nil))
            }
            waves.append(Wave(groups: groups))
        }
        return Level(waves: waves, boss: Boss.all[Melisse.random(Boss.all.count)])
    }
}

struct Wave {
    var groups: [Group]
}

struct Group {
    var kanji: Character
    var shape: Shape
    var formation: Formation
    var shootingStyleDefinition: ShootingStyleDefinition?
}

enum Shape {
    case round
    case triangular
    case losange
}

enum Formation {
    /// Descend en ligne droite à vitesse constante.
    case vertical

    /// Descend en faisant des lignes horizontales, chaque ligne va dans un sens opposé.
    case horizontal

    /// Descend en faisant des lignes à 45°.
    case diagonal
    
    /// Arrive du haut de l'écran puis fait du surplace en tirant.
    case stationary
    
    /// Arrive doucement du haut de l'écran puis accélère d'un coup en tombant.
    /// TODO: Créer les ennemis à quelques secondes d'interval et décaler verticalement l'emplacement de création pour éviter qu'ils se superposent.
    case fall
    
    /// Descend en faisant une courbe en forme de S.
    case curve
    
    /// Descend en faisant un demi cercle depuis un des bords supérieur de l'écran.
    case quarterCircle
    
    /// Tourne en faisant un cercle avec 1 trou. Destructible uniquement en tuant un kanji désigné.
    case circle
    
    /// Création aléatoire de beaucoup de petits ennemis faibles.
    case swarm
    
    /// Apparaît depuis l'arrière plan et reste stationnaire.
    case rise
    
    static let all = [Formation.vertical, .horizontal, .stationary, .fall, .curve, .quarterCircle, .circle, .swarm, .rise]
}

enum Boss {
    /// Constitué de 2 kanjis qui ont une lecture irrégulière. Ils se séparent et s'assemblent afin de changer de lecture et éviter les tirs.
    case irregularReading
    
    /// Un ennemi double face avec un sens contraire sur chaque face (par exemple : 白/黒 ou 明/暗).
    case antonym
    
    /// Un ennemi qui change de taille et de kanji (par exemple : 大/小 ou 増/減). Quand gros, tirs puissants. Quand petit, déplacement rapide.
    case bigSmall
    
    /// Un ennemi central avec un sens regroupant le sens de plusieurs autres petits kanjis qui tournent autour (par exemple : 虹 + 赤黄緑青紫 ou 百 + 一二三四五). L'ennemi central ne tire pas tant qu'il reste des satellites. Les satellites tournent en cercle. Le cercle s'élargit et rétrécie. Les satellites tirent l'un à l'extérieur, l'autre à l'extérieur quand le cercle s'agrandit.
    case rainbow
    
    static let all = [Boss.irregularReading, .antonym, .bigSmall, .rainbow]
}
