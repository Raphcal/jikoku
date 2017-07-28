//
//  ShapeSize.swift
//  Yamato
//
//  Created by Raphaël Calabro on 28/07/2017.
//  Copyright © 2017 Raphaël Calabro. All rights reserved.
//

import Foundation
import Melisse

fileprivate let sizeDistribution = Distribution(itemsWithProbabilities: [
    ShapeSize.smaller: 5,
    .small: 10,
    .medium: 50,
    .big: 10,
    .bigger: 5])

enum ShapeSize : Enumerable {
    case smaller
    case small
    case medium
    case big
    case bigger
    
    var pixelSize: GLfloat {
        switch self {
        case .smaller:
            return 16
        case .small:
            return 32
        case .medium:
            return 48
        case .big:
            return 64
        case .bigger:
            return 96
        }
    }
    
    var randomCount: Int {
        switch self {
        case .smaller:
            return Melisse.random(from: 10, to: 20)
        case .small:
            return Melisse.random(from: 5, to: 10)
        case .medium:
            return Melisse.random(from: 3, to: 5)
        case .big:
            return Melisse.random(from: 1, to: 2)
        case .bigger:
            return 1
        }
    }
    
    static let all = [ShapeSize.smaller, .small, .medium, .big, .bigger]
    
    static var random: ShapeSize {
        return sizeDistribution.randomItem
    }
}