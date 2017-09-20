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
    var spriteDefinition: Int? { get set }
}

protocol HasBlueprints {
    var blueprints: [SpriteBlueprint] { get }
    var spriteDefinitions: [Int] { get set }
}

extension HasBlueprint {
    var blueprints: [SpriteBlueprint] {
        return [blueprint]
    }
    var definitionIndex: Int? {
        get {
            return !spriteDefinitions.isEmpty ? spriteDefinitions[0] : nil
        }
        set {
            if let newValue = newValue {
                spriteDefinitions = [newValue]
            } else {
                spriteDefinitions = []
            }
        }
    }
}
