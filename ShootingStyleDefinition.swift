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

protocol ShootingStyleDefinition {

    /// Nombre de tirs
    var shotAmount: Int { get }
    /// Augmentation ou diminution du nombre de tirs
    var shotAmountVariation: Int { get }
    
    /// Vitesse d'un tir
    var shotSpeed: GLfloat { get }
    /// Interval de temps entre chaque tir
    var shootInterval: TimeInterval { get }
    
    /// Angle initial du tir
    var baseAngle: GLfloat { get }
    
    /// Nombre d'inversions
    var inversions: ShootingStyleInversion { get }
    /// Nombre de tirs avant l'inversion
    var inversionInterval: Int { get }
    
    /// Numéro du sprite dans l'atlas
    var spriteDefinition: Int { get }
    
    /// Créé une instance de ShootingStyle à partir de cette définition.
    /// - Parameter spriteFactory: Fabrique de sprites.
    /// - Returns: Une nouvelle instance de ShootingStyle basée sur cette définition.
    func shootingStyle(spriteFactory: SpriteFactory) -> ShootingStyle

}

struct StraightShootingStyleDefinition : ShootingStyleDefinition {

    var shotAmount: Int
    var shotAmountVariation: Int
    
    var shotSpeed: GLfloat
    var shootInterval: TimeInterval
    
    var baseAngle: GLfloat
    
    var inversions: ShootingStyleInversion
    var inversionInterval: Int
    
    var spriteDefinition: Int
    
    /// Espace entre chaque tir.
    var space: GLfloat
    
    func shootingStyle(spriteFactory: SpriteFactory) -> ShootingStyle {
        return StraightShootingStyle(definition: self, spriteFactory: spriteFactory)
    }
    
}
