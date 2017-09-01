//
//  ShootingStyleDefinition.swift
//  Yamato
//
//  Created by Raphaël Calabro on 20/07/2017.
//  Copyright © 2017 Raphaël Calabro. All rights reserved.
//

import Foundation
import GLKit
import Melisse

struct ShootingStyleInversion : OptionSet {
    let rawValue: UInt8
    
    static let x = ShootingStyleInversion(rawValue: 1)
    static let y = ShootingStyleInversion(rawValue: 2)
    static let aim = ShootingStyleInversion(rawValue: 4)
    static let angle = ShootingStyleInversion(rawValue: 8)
    static let amount = ShootingStyleInversion(rawValue: 16)

}

enum ShotOrigin {
    case center, front
}

protocol ShootingStyleDefinition {

    /// Point d'origine des tirs
    var origin: ShotOrigin { get }
    
    /// Dommages provoqués par chaque tir
    var damage: Int { get set }
    
    /// Nombre de tirs
    var shotAmount: Int { get }
    /// Augmentation ou diminution du nombre de tirs
    var shotAmountVariation: Int { get }
    
    /// Vitesse d'un tir
    var shotSpeed: GLfloat { get }
    /// Interval de temps entre chaque tir
    var shootInterval: TimeInterval { get }
    
    /// Nombre d'inversions
    var inversions: ShootingStyleInversion { get }
    /// Nombre de tirs avant l'inversion
    var inversionInterval: Int { get }
    
    /// Numéro du sprite dans l'atlas
    var spriteDefinition: Int { get set }
    
    /// Créé une instance de ShootingStyle à partir de cette définition.
    /// - Parameter spriteFactory: Fabrique de sprites.
    /// - Returns: Une nouvelle instance de ShootingStyle basée sur cette définition.
    func shootingStyle(spriteFactory: SpriteFactory) -> ShootingStyle

}
