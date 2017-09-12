//
//  HasBlueprint.swift
//  Jikoku
//
//  Created by Raphaël Calabro on 07/09/2017.
//  Copyright © 2017 Raphaël Calabro. All rights reserved.
//

import Foundation

protocol HasBlueprint : HasBlueprints {
    var blueprint: SpriteBlueprint { get }
    var definitionIndex: Int? { get set }
}

protocol HasBlueprints {
    var blueprints: [SpriteBlueprint] { get }
    var definitionIndexes: [Int] { get set }
}

extension HasBlueprint {
    var blueprints: [SpriteBlueprint] {
        return [blueprint]
    }
    var definitionIndex: Int? {
        get {
            return !definitionIndexes.isEmpty ? definitionIndexes[0] : nil
        }
        set {
            if let newValue = newValue {
                definitionIndexes = [newValue]
            } else {
                definitionIndexes = []
            }
        }
    }
}
