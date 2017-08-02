//
//  FormationManager.swift
//  Yamato
//
//  Created by Raphaël Calabro on 02/08/2017.
//  Copyright © 2017 Raphaël Calabro. All rights reserved.
//

import Foundation
import Melisse

class FormationManager {
    
    var definitions = [FormationDefinition]() {
        didSet {
            intervals = [TimeInterval](repeating: 0, count: definitions.count)
        }
    }
    var intervals = [TimeInterval]()
    
    func update(since lastUpdate: TimeInterval, spriteFactory: SpriteFactory) {
        for index in 0 ..< definitions.count {
            let definition = definitions[index]
            var interval = intervals[index] + lastUpdate
            if interval > definition.interval {
                interval -= definition.interval
                _ = definition.creationPoints.map {
                    let sprite = spriteFactory.sprite(1, topLeft: $0)
                    return sprite
                }
            }
        }
    }
    
}
