//
//  Level.swift
//  Yamato
//
//  Created by Raphaël Calabro on 24/07/2017.
//  Copyright © 2017 Raphaël Calabro. All rights reserved.
//

import Foundation

struct Level {
    var waves: [Wave]
    var boss: Boss
}

struct Wave {
    var groups: [Group]
}

struct Group {
    var formation: Formation
    var kanji: Character
    var shootingStyle: ShootingStyle
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
}
