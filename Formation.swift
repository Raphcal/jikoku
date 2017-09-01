//
//  Formation.swift
//  Yamato
//
//  Created by Raphaël Calabro on 28/07/2017.
//  Copyright © 2017 Raphaël Calabro. All rights reserved.
//

import Foundation
import Melisse

enum Formation : Enumerable {
    /// Pas de formation.
    case none
    
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
    case topLeftQuarterCircle
    case topRightQuarterCircle
    
    /// Tourne en faisant un cercle avec 1 trou. Destructible uniquement en tuant un kanji désigné.
    case circle
    
    /// Création aléatoire de beaucoup de petits ennemis faibles.
    case swarm
    
    /// Apparaît depuis l'arrière plan et reste stationnaire.
    case rise
    
    func motion(lifePoints: Int, gameScene: GameScene) -> EnemyMotion {
        switch self {
        case .stationary:
            return StationaryEnemyMotion(lifePoints: lifePoints, gameScene: gameScene)
        case .topLeftQuarterCircle:
            return QuarterCircleEnemyMotion(lifePoints: lifePoints, gameScene: gameScene, direction: .left)
        case .topRightQuarterCircle:
            return QuarterCircleEnemyMotion(lifePoints: lifePoints, gameScene: gameScene, direction: .right)
        default:
            return EnemyMotion(lifePoints: lifePoints, gameScene: gameScene)
        }
    }
    
    static let all = [Formation.vertical, .horizontal, .stationary, .fall, .curve, .topLeftQuarterCircle, .topRightQuarterCircle, .circle, .swarm, .rise]
}
